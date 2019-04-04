//
//  WAAVSEExportCommand.h
//  WA
//
//  Created by 黄锐灏 on 2017/8/14.
//  Copyright © 2017年 黄锐灏. All rights reserved.
//

#import "WAAVSECommand.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WAAVSEExportCommand : WAAVSECommand

@property (nonatomic , strong)AVAssetExportSession *exportSession;

/**
 只有在开启画布的时候并且不是自动分辩率下才有效
 */
@property (nonatomic , assign) NSInteger videoQuality;

- (void)performSaveByPath:(NSString *)path;

- (void)performSaveAsset:(AVAsset *)asset byPath:(NSString *)path;

@end
