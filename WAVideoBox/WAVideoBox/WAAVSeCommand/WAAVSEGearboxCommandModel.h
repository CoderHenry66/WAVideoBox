//
//  WAAVSEGearboxCommandModel.h
//  WA
//
//  Created by 黄锐灏 on 2018/1/5.
//  Copyright © 2018年 黄锐灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface WAAVSEGearboxCommandModel : NSObject

@property (nonatomic , assign) CMTime beganDuration;

@property (nonatomic , assign) CMTime duration;

@property (nonatomic , assign) CGFloat scale;


@end
