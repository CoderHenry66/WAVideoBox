//
//  WAAVSEGearboxCommand.h
//  WA
//
//  Created by 黄锐灏 on 2018/1/5.
//  Copyright © 2018年 黄锐灏. All rights reserved.
//

#import "WAAVSECommand.h"
@class WAAVSEGearboxCommandModel;

@interface WAAVSEGearboxCommand : WAAVSECommand

- (void)performWithAsset:(AVAsset *)asset scale:(CGFloat)scale;

- (void)performWithAsset:(AVAsset *)asset models:(NSArray <WAAVSEGearboxCommandModel *> *)gearboxModels;

@end

