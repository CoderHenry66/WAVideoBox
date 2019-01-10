//
//  WAAVSEVideoMixCommand.h
//  WA
//
//  Created by 黄锐灏 on 2017/9/15.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import "WAAVSECommand.h"

@interface WAAVSEVideoMixCommand : WAAVSECommand

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset;

- (void)performWithAssets:(NSArray *)assets;

@end
