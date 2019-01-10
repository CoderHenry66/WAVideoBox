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

@property AVAssetExportSession *exportSession;

@property (nonatomic , assign) NSInteger videoQuality;

- (void)performSaveByPath:(NSString *)path;

- (void)performSaveAsset:(AVAsset *)asset byPath:(NSString *)path;

@end
