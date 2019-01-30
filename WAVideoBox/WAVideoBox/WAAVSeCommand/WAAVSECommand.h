//
//  WAAVSECommand.h
//  WA
//
//  Created by 黄锐灏 on 2017/8/14.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAAVSEComposition.h"
#import <UIKit/UIKit.h>


@interface WAAVSECommand : NSObject

- (instancetype)initWithComposition:(WAAVSEComposition *)composition;


@property (nonatomic , strong) WAAVSEComposition *composition;

/**
 视频信息初始化

 @param asset asset
 */
- (void)performWithAsset:(AVAsset *)asset;

/**
 视频融合器初始化
 */
- (void)performVideoCompopsition;

/**
 音频融合器初始化
 */
- (void)performAudioCompopsition;

 /**
  计算旋转角度
  
  @param transform transForm
  @return 角度
  */
- (NSUInteger)degressFromTransform:(CGAffineTransform)transForm;

@end

extern NSString* const WAAVSEExportCommandCompletionNotification;

extern NSString* const WAAVSEExportCommandError;

