//
//  WAAVSEReplaceSoundCommand.h
//  WA
//
//  Created by 黄锐灏 on 2017/11/23.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import "WAAVSECommand.h"

@interface WAAVSEReplaceSoundCommand : WAAVSECommand

- (void)performWithAsset:(AVAsset *)asset replaceAsset:(AVAsset *)replaceAsset;

@end
