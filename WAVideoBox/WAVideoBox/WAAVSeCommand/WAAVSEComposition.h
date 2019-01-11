//
//  WAAVSEComposition.h
//  YCH
//
//  Created by 黄锐灏 on 2017/9/26.
//  Copyright © 2017 黄锐灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface WAAVSEComposition : NSObject

/**
 视频轨道信息
 */
@property (nonatomic , strong) AVMutableComposition *mutableComposition;

/**
 视频操作指令
 */
@property (nonatomic , strong) AVMutableVideoComposition *mutableVideoComposition;

/**
 音频操作指令
 */
@property (nonatomic , strong) AVMutableAudioMix *mutableAudioMix;

/**
 视频时长(变速/裁剪后) PS:后续版本会为每条轨道单独设置duration
 */
@property (nonatomic , assign) CMTime duration;

/**
 视频分辩率
 */
@property (nonatomic , copy) NSString *presetName;

/**
 视频质量
 */
@property (nonatomic , assign) NSInteger videoQuality;

/**
 输出文件格式
 */
@property (nonatomic , copy) AVFileType fileType;

/**
 视频操作参数数组
 */
@property (nonatomic , strong) NSMutableArray <AVMutableVideoCompositionInstruction *> *instructions; 

/**
 音频操作参数数组
 */
@property (nonatomic , strong) NSMutableArray <AVMutableAudioMixInputParameters *> *audioMixParams;

/**
 画布父容器
 */
@property (nonatomic , strong) CALayer *parentLayer;

/**
 原视频容器
 */
@property (nonatomic , strong) CALayer *videoLayer;


@property (nonatomic , assign) CGSize lastInstructionSize;


@end

NS_ASSUME_NONNULL_END
