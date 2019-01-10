//
//  WAAVSERangeCommand.h
//  WA
//
//  Created by 黄锐灏 on 2018/1/29.
//  Copyright © 2018年 黄锐灏. All rights reserved.
//

#import "WAAVSECommand.h"

@interface WAAVSERangeCommand : WAAVSECommand

- (void)performWithAsset:(AVAsset *)asset timeRange:(CMTimeRange)range;

@end
