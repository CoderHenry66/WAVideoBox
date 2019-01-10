//
//  WAAVSEVideoMixCommand.m
//  WA
//
//  Created by 黄锐灏 on 2017/9/15.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import "WAAVSEVideoMixCommand.h"
@interface WAAVSEVideoMixCommand ()

@end

@implementation WAAVSEVideoMixCommand

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset{
    
    [super performWithAsset:asset];

    [self mixWithAsset:mixAsset];
    
    
}

- (void)performWithAssets:(NSArray *)assets{
    
    AVAsset *asset = assets[0];
    [super performWithAsset:asset];
    
    for (int i = 1; i < assets.count; i ++) {
        [self mixWithAsset:assets[i]];
    }

}

- (void)mixWithAsset:(AVAsset *)mixAsset{
    
    NSError *error = nil;
    
    AVAssetTrack *mixAssetVideoTrack = nil;
    AVAssetTrack *mixAssetAudioTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[mixAsset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        mixAssetVideoTrack = [mixAsset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    
    if ([[mixAsset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        mixAssetAudioTrack = [mixAsset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    if (mixAssetVideoTrack) {
        
        CGSize natureSize = mixAssetVideoTrack.naturalSize;
        NSInteger degress = [self degressFromTransform:mixAssetVideoTrack.preferredTransform];
        
        AVMutableCompositionTrack *videoTrack =  [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo] lastObject];
        BOOL needNewInstrunction = YES;
        
        if (!(degress % 360) && !self.composition.instructions.count && CGSizeEqualToSize(natureSize, self.composition.mutableComposition.naturalSize) && videoTrack) {
             [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetVideoTrack atTime:self.composition.duration error:&error];
            needNewInstrunction = NO;
        }else if (!(degress % 360) && self.composition.instructions.count) {
            CGAffineTransform transform;
            AVMutableVideoCompositionInstruction *instruction = [self.composition.instructions lastObject];
            AVMutableVideoCompositionLayerInstruction *layerInstruction = (AVMutableVideoCompositionLayerInstruction *)instruction.layerInstructions[0];
            [layerInstruction getTransformRampForTime:self.composition.duration startTransform:&transform endTransform:NULL timeRange:NULL];
            
            if (CGAffineTransformEqualToTransform (transform, mixAssetVideoTrack.preferredTransform) && CGSizeEqualToSize(self.composition.lastInstructionSize, natureSize)) {
                
                [instruction setTimeRange:CMTimeRangeMake(instruction.timeRange.start, CMTimeAdd(instruction.timeRange.duration, mixAsset.duration))];
                [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetVideoTrack atTime:self.composition.duration error:&error];
                needNewInstrunction = NO;
            }else{
                needNewInstrunction = YES;
            }
        }
      
        if (needNewInstrunction) {

            [super performVideoCompopsition];
        
            AVMutableCompositionTrack *newVideoTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
            [newVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetVideoTrack atTime:self.composition.duration error:&error];
        
            AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            [instruction setTimeRange:CMTimeRangeMake(self.composition.duration, mixAsset.duration)];

            AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:newVideoTrack];
        
            CGSize renderSize = self.composition.mutableVideoComposition.renderSize;
        
            if (degress == 90 || degress == 270) {
                natureSize = CGSizeMake(natureSize.height, natureSize.width);
            }
        
        
            CGFloat scale = MIN(renderSize.width / natureSize.width, renderSize.height / natureSize.height);
            
            self.composition.lastInstructionSize = CGSizeMake(natureSize.width * scale, natureSize.height * scale);
        
            // 移至中心点
            CGPoint translate = CGPointMake((renderSize.width - natureSize.width * scale  ) * 0.5, (renderSize.height - natureSize.height * scale ) * 0.5);
        
            CGAffineTransform naturalTransform = mixAssetVideoTrack.preferredTransform;
            CGAffineTransform preferredTransform = CGAffineTransformMake(naturalTransform.a * scale, naturalTransform.b * scale, naturalTransform.c * scale, naturalTransform.d * scale, naturalTransform.tx * scale + translate.x, naturalTransform.ty * scale + translate.y);
        
            [layerInstruction setTransform:preferredTransform atTime:kCMTimeZero];
        
            instruction.layerInstructions = @[layerInstruction];
        
            [self.composition.instructions addObject:instruction];
            self.composition.mutableVideoComposition.instructions = self.composition.instructions;
        }
        
    }
    
    if (mixAssetAudioTrack) {
        if (self.composition.mutableAudioMix) {
            AVMutableCompositionTrack *audioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetAudioTrack atTime:self.composition.duration error:&error];
            
            AVMutableAudioMixInputParameters *audioParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:mixAssetAudioTrack];
            [audioParam setVolume:1.0 atTime:kCMTimeZero];
            [self.composition.audioMixParams addObject:audioParam];
            
            self.composition.mutableAudioMix.inputParameters = self.composition.audioMixParams;
        }else{
            
            AVMutableCompositionTrack *audioTrack =  [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio] lastObject];
            
            if (!audioTrack) {
                audioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            }
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, mixAsset.duration) ofTrack:mixAssetAudioTrack atTime:self.composition.duration error:&error];
        }

    }
    
    self.composition.duration = CMTimeAdd(self.composition.duration, mixAsset.duration);
    
}

@end
