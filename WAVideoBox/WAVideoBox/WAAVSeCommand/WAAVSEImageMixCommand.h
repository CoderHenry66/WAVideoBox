//
//  WAAVSEImageMixCommand.h
//  WA
//
//  Created by 黄锐灏 on 2017/9/25.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import "WAAVSECommand.h"

@interface WAAVSEImageMixCommand : WAAVSECommand


@property (nonatomic , assign) BOOL imageBg;

@property (nonatomic , strong) UIImage *image;

@property (nonatomic , strong) NSURL *fileUrl;

// 传回要放的图片位置
- (void)imageLayerRectWithVideoSize:(CGRect (^) (CGSize videoSize))imageLayerRect;

@end
