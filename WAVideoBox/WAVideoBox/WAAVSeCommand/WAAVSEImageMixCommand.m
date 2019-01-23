//
//  WAAVSEImageMixCommand.m
//  WA
//
//  Created by 黄锐灏 on 2017/9/25.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import "WAAVSEImageMixCommand.h"


@interface WAAVSEImageMixCommand ()


@property (nonatomic , copy) CGRect (^imageLayerRect)(CGSize);

@end

@implementation WAAVSEImageMixCommand

- (void)performWithAsset:(AVAsset *)asset{
    
    [super performWithAsset:asset];
    CGSize videoSize;
    
    // 3､通过videoCompostion合成
    if ([[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        // 3.1､
       
        // 3.2､创建视频画面合成器
        [super performVideoCompopsition];
        
        videoSize = self.composition.mutableVideoComposition.renderSize;
        
        CALayer *imageLayer;
        if (self.imageLayerRect) {
            imageLayer = [self buildImageLayerWithRect:self.imageLayerRect(videoSize)];
            
            if (self.fileUrl) {
                [imageLayer addAnimation:[self buildAnimationForGif] forKey:@"gif"];
            }
        }
        
        if (!self.composition.videoLayer || !self.composition.parentLayer) {
            CALayer *parentLayer = [CALayer layer];
            CALayer *videoLayer = [CALayer layer];
            parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
            videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
            self.composition.videoLayer = videoLayer;
            self.composition.parentLayer = parentLayer;
        }
        
        if (self.imageBg) {
            self.composition.videoLayer.opaque = YES;
             self.composition.videoLayer.opacity = 0.8;
            [self.composition.parentLayer addSublayer:imageLayer];
            [self.composition.parentLayer addSublayer:self.composition.videoLayer];
        }else{
            [self.composition.parentLayer addSublayer:self.composition.videoLayer];
            [self.composition.parentLayer addSublayer:imageLayer];
        }
        
        self.composition.mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer: self.composition.videoLayer inLayer: self.composition.parentLayer];
        
    }
  
}

- (void)imageLayerRectWithVideoSize:(CGRect (^)(CGSize))imageLayerRect{
    if (imageLayerRect) {
        self.imageLayerRect = imageLayerRect;
    }
}

- (CALayer *)buildImageLayerWithRect:(CGRect)rect{
    
    CALayer *imageLayer = [CALayer layer];
    if (self.image) {
        imageLayer.contents = (__bridge id) (self.image.CGImage);
    }
    imageLayer.frame = rect;
    return imageLayer;
}

- (CAKeyframeAnimation *)buildAnimationForGif{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
    animation.removedOnCompletion = YES;
    
    NSMutableArray * frames = [NSMutableArray new];    NSMutableArray *delayTimes = [NSMutableArray new];
    CGFloat totalTime = 0.0;
    CGFloat gifWidth;
    CGFloat gifHeight;
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)self.fileUrl, NULL);
   
    size_t frameCount = CGImageSourceGetCount(gifSource);
    
    for (size_t i = 0; i < frameCount; ++i) {
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:(__bridge id)frame];        CGImageRelease(frame);

        NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
      
        NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime]];
        
        totalTime = totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFUnclampedDelayTime] floatValue];
    }
    
    if (gifSource) CFRelease(gifSource);
    
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
    CGFloat currentTime = 0;
    NSInteger count = delayTimes.count;
    for (int i = 0; i < count; ++i) {
        
        [times addObject:[NSNumber numberWithFloat:(currentTime / totalTime)]];
        currentTime += [[delayTimes objectAtIndex:i] floatValue];
    }
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < count; ++i) {
        [images addObject:[frames objectAtIndex:i]];
    }
    
    animation.keyTimes = times;
    animation.values = images;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = totalTime;
    animation.repeatCount = HUGE_VALF;
    return animation;
}
@end
