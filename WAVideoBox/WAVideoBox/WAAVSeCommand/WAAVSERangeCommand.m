//
//  WAAVSERangeCommand.m
//  WA
//
//  Created by 黄锐灏 on 2018/1/29.
//  Copyright © 2018年 黄锐灏. All rights reserved.
//

#import "WAAVSERangeCommand.h"

@implementation WAAVSERangeCommand

- (void)performWithAsset:(AVAsset *)asset timeRange:(CMTimeRange)range{
    
    [super performWithAsset:asset];

    if (CMTimeCompare(self.composition.duration, CMTimeAdd(range.start, range.duration)) != 1) {
        NSAssert(NO, @"Range out of video duration");
    }
    
    // 轨道裁剪
    for (AVMutableCompositionTrack *compositionTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio]) {
        
        [self subTimeRaneWithTrack:compositionTrack range:range];
        
    }
    
    for (AVMutableCompositionTrack *compositionTrack in [self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo]) {
        
        [self subTimeRaneWithTrack:compositionTrack range:range];
        
    }
    
    self.composition.duration = range.duration;
   
}

- (void)subTimeRaneWithTrack:(AVMutableCompositionTrack *)compositionTrack range:(CMTimeRange)range{
    
    CMTime endPoint = CMTimeAdd(range.start, range.duration);
    if (CMTimeCompare(self.composition.duration,endPoint) != -1) {
        [compositionTrack removeTimeRange:CMTimeRangeMake(endPoint,CMTimeSubtract(self.composition.duration, endPoint))];
    }
    
    if (CMTimeGetSeconds(range.start)) {
        [compositionTrack removeTimeRange:CMTimeRangeMake(kCMTimeZero, range.start)];
    }
    
   
}

@end
