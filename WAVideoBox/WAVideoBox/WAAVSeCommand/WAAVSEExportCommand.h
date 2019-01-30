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

@property (nonatomic , assign) NSInteger videoQuality;

- (void)performSaveByPath:(NSString *)path;

- (void)performSaveAsset:(AVAsset *)asset byPath:(NSString *)path;

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
