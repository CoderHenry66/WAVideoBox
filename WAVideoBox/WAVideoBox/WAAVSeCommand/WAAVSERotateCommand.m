//
//  WAAVSERotateCommand.m
//  WA
//
//  Created by 黄锐灏 on 2018/1/29.
//  Copyright © 2018年 黄锐灏. All rights reserved.
//

#import "WAAVSERotateCommand.h"

@implementation WAAVSERotateCommand

- (void)performWithAsset:(AVAsset *)asset degress:(NSUInteger)degress{
    [super performWithAsset:asset];
  
    [super performVideoCompopsition];
    
    if(self.composition.mutableVideoComposition.instructions.count > 1){
         NSAssert(NO, @"This method does not support multi-video processing for the time being.");
        //暂不支持不同分辩率的视频合并马上再旋转
        //ps:可以分开操作，先旋转一个再apeed再旋转即可,使用骚操作完成
    }
    
    degress -= degress % 360 % 90 ;
    
    for (AVMutableVideoCompositionInstruction *instruction in self.composition.mutableVideoComposition.instructions) {
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = (AVMutableVideoCompositionLayerInstruction *)(instruction.layerInstructions)[0];
        CGAffineTransform t1;
        CGAffineTransform t2;
        CGSize renderSize;
        
        // 角度调整
        degress -= degress % 360 % 90;
        
        if (degress == 90) {
            t1 = CGAffineTransformMakeTranslation(self.composition.mutableVideoComposition.renderSize.height, 0.0);
            renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.height, self.composition.mutableVideoComposition.renderSize.width);
        }else if (degress == 180){
            t1 = CGAffineTransformMakeTranslation(self.composition.mutableVideoComposition.renderSize.width, self.composition.mutableVideoComposition.renderSize.height);
            renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.width, self.composition.mutableVideoComposition.renderSize.height);
        }else if (degress == 270){
            t1 = CGAffineTransformMakeTranslation(0.0, self.composition.mutableVideoComposition.renderSize.width);
            renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.height, self.composition.mutableVideoComposition.renderSize.width);
        }else{
            t1 = CGAffineTransformMakeTranslation(0.0, 0.0);
            renderSize = CGSizeMake(self.composition.mutableVideoComposition.renderSize.width, self.composition.mutableVideoComposition.renderSize.height);
        }
        
        // Rotate transformation
        t2 = CGAffineTransformRotate(t1, (degress / 180.0) * M_PI );
        
        self.composition.mutableComposition.naturalSize = self.composition.mutableVideoComposition.renderSize = renderSize;
        
        CGAffineTransform existingTransform;
        
        if (![layerInstruction getTransformRampForTime:[self.composition.mutableComposition duration] startTransform:&existingTransform endTransform:NULL timeRange:NULL]) {
            [layerInstruction setTransform:t2 atTime:kCMTimeZero];
        } else {
            CGAffineTransform newTransform =  CGAffineTransformConcat(existingTransform, t2);
            [layerInstruction setTransform:newTransform atTime:kCMTimeZero];
        }
        
        instruction.layerInstructions = @[layerInstruction];
        
    }
    
    // 将容器大小旋转，若没有anmaitionTool的修改，则直接跳过此步
    if (self.composition.videoLayer || self.composition.parentLayer) {
        
        for (CALayer *sublayer in self.composition.parentLayer.sublayers) {
            if (sublayer == self.composition.videoLayer) {
                continue;
            }
            [self converRect:sublayer naturalRenderSize:self.composition.mutableVideoComposition.renderSize renderSize:self.composition.mutableVideoComposition.renderSize];
            sublayer.transform = CATransform3DRotate(sublayer.transform, -(degress / 180.0 * M_PI), 0, 0, 1);
        }
        
        if (degress == 90 || degress == 270) {
            self.composition.videoLayer.frame = CGRectMake(0, 0, self.composition.videoLayer.bounds.size.height, self.composition.videoLayer.bounds.size.width);
            self.composition.parentLayer.frame = CGRectMake(0, 0, self.composition.parentLayer.bounds.size.height, self.composition.parentLayer.bounds.size.width);
        }
        
    }
   
}


// 调整旋转
- (NSUInteger)degressFromTransform:(CGAffineTransform)transForm
{
    NSUInteger degress = 0;
    
    if(transForm.a == 0 && transForm.b == 1.0 && transForm.c == -1.0 && transForm.d == 0){
        // Portrait
        degress = 90;
    }else if(transForm.a == 0 && transForm.b == -1.0 && transForm.c == 1.0 && transForm.d == 0){
        // PortraitUpsideDown
        degress = 270;
    }else if(transForm.a == 1.0 && transForm.b == 0 && transForm.c == 0 && transForm.d == 1.0){
        // LandscapeRight
        degress = 0;
    }else if(transForm.a == -1.0 && transForm.b == 0 && transForm.c == 0 && transForm.d == -1.0){
        // LandscapeLeft
        degress = 180;
    }
    
    return degress;
}

- (void)converRect:(CALayer *)layer naturalRenderSize:(CGSize)size renderSize:(CGSize)renderSize{
    
    
    
    if (!CGSizeEqualToSize(size, renderSize)) {
        // 还原绝对位置
        CGRect relativeRect = CGRectMake(layer.frame.origin.x / size.width, 1 - (layer.frame.origin.y + layer.bounds.size.height) / size.height, layer.bounds.size.width / size.width, layer.bounds.size.height / size.height);
        
        layer.frame = CGRectMake(renderSize.width * relativeRect.origin.x,renderSize.height * (1 - relativeRect.origin.y) - renderSize.height * relativeRect.size.height,renderSize.width * relativeRect.size.width, renderSize.height * relativeRect.size.height);
        
    }
}

@end
