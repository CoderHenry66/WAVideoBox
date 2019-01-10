//
//  WAAVSEDubbedCommand.h
//  WA
//
//  Created by 黄锐灏 on 2017/11/27.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import "WAAVSECommand.h"

@interface WAAVSEDubbedCommand : WAAVSECommand

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset;

/**
 插入时间
 */
@property (nonatomic , assign) CMTime insertTime;

/**
 原音频音量 0.0~1.0
 */
@property (nonatomic , assign) float audioVolume;

/**
 配音音量 0.0~1.0
 */
@property (nonatomic , assign) float mixVolume;

@end
