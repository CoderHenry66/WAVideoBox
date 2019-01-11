//
//  WAAVSEComposition.m
//  YCH
//
//  Created by 黄锐灏 on 2017/9/26.
//  Copyright © 2017 黄锐灏. All rights reserved.
//

#import "WAAVSEComposition.h"

@implementation WAAVSEComposition

- (NSMutableArray<AVMutableAudioMixInputParameters *> *)audioMixParams{
    if (!_audioMixParams) {
        _audioMixParams = [NSMutableArray array];
    }
    return _audioMixParams;
}

- (NSMutableArray<AVMutableVideoCompositionInstruction *> *)instructions{
    if (!_instructions) {
        _instructions = [NSMutableArray array];
    }
    return _instructions;
}

@end
