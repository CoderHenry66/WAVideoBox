//
//  ViewController.m
//  WAVideoBox
//
//  Created by 黄锐灏 on 2019/1/6.
//  Copyright © 2019 黄锐灏. All rights reserved.
//

#import "ViewController.h"
#import "WAVideoBox.h"
#import "PlayViewController.h"
@interface ViewController ()

@property (nonatomic , copy) NSString *videoPath;

@property (nonatomic , copy) NSString *testOnePath;

@property (nonatomic , copy) NSString *testTwoPath;

@property (nonatomic , copy) NSString *testThreePath;

@property (nonatomic , strong) WAVideoBox *videoBox;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoBox = [WAVideoBox new];
  
    _videoPath = [[NSBundle mainBundle] pathForResource:@"nature.mp4" ofType:nil];
  
    _testOnePath = [[NSBundle mainBundle] pathForResource:@"test1.mp4" ofType:nil];
    _testTwoPath = [[NSBundle mainBundle] pathForResource:@"test2.mp4" ofType:nil];
    _testThreePath = [[NSBundle mainBundle] pathForResource:@"test3.mp4" ofType:nil];
    
}

#pragma mari private method

- (NSString *)buildFilePath{
    
    return [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%f.mp4", [[NSDate date] timeIntervalSinceReferenceDate]]];
}

- (void)goToPlayVideoByFilePath:(NSString *)filePath{
    PlayViewController *playVc = [PlayViewController new];
    [playVc loadWithFilePath:filePath];
    [self.navigationController pushViewController:playVc animated:YES];
}

#pragma mark 常规操作
- (IBAction)rangeVideo:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(CMTimeMake(3600, 600), CMTimeMake(3600, 600))];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
}

- (IBAction)compressVideo:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_videoPath];
    _videoBox.ratio = WAVideoExportRatioLowQuality;
//    _videoBox.videoQuality = 1; 有两种方法可以压缩
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
        wself.videoBox.ratio = WAVideoExportRatio960x540;
        wself.videoBox.videoQuality = 0;
    }];
}

- (IBAction)addWaterMark:(id)sender {
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox appendWaterMark:[UIImage imageNamed:@"waterMark"] relativeRect:CGRectMake(0.7, 0.7, 0.2, 0.12)];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
}

- (IBAction)rotateVideo:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox rotateVideoByDegress:90];
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
}

- (IBAction)replaceVideo:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox replaceSoundBySoundPath:_testOnePath];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
}

- (IBAction)mixVideo:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_testThreePath];
    [_videoBox appendVideoByPath:_testTwoPath];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
}

- (IBAction)mixSound:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox dubbedSoundBySoundPath:_testThreePath];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
    
}

- (IBAction)gearVideo:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox gearBoxWithScale:3];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
}


#pragma mark 混合操作
- (IBAction)composeEdit:(id)sender {
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    // 将1号拼接到video，用2号的音频替换，给视频加一个水印，旋转180度，混上3号的音,速度加快两倍，把生好的视频裁6-12秒，压缩
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox appendVideoByPath:_testThreePath];
    [_videoBox replaceSoundBySoundPath:_testTwoPath];
    [_videoBox appendWaterMark:[UIImage imageNamed:@"waterMark"] relativeRect:CGRectMake(0.7, 0.7, 0.2, 0.1)];
    
    [_videoBox rotateVideoByDegress:180];
    [_videoBox dubbedSoundBySoundPath:_testOnePath];
    [_videoBox gearBoxWithScale:2];
    
    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(CMTimeMake(2400, 600), CMTimeMake(3600, 600))];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
    
    
}


#pragma mark 骚操作
- (IBAction)magicEdit:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    // 放入原视频，换成1号的音，再把3号视频放入混音,剪其中8秒
    // 拼1号视频，给1号水印,剪其中8秒
    // 拼2号视频，给2号变速
    // 拼3号视频，旋转180,剪其中8秒
    // 把最后的视频再做一个变速
    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox replaceSoundBySoundPath:_testOnePath];
    [_videoBox dubbedSoundBySoundPath:_testThreePath];
    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(3600, 600))];
    
    [_videoBox appendVideoByPath:_testOnePath];
    [_videoBox appendWaterMark:[UIImage imageNamed:@"waterMark"] relativeRect:CGRectMake(0.7, 0.7, 0.2, 0.12)];
    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(CMTimeMake(3600, 600), CMTimeMake(3600, 600))];
    
    [_videoBox appendVideoByPath:_testTwoPath];
    [_videoBox gearBoxWithScale:2];
    
    [_videoBox appendVideoByPath:_testThreePath];
    [_videoBox rotateVideoByDegress:180];
    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(3600, 600))];
    
    [_videoBox commit];
    [_videoBox gearBoxWithScale:2];
    
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError * error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
        }
    }];
    
   
}

- (IBAction)natureVideo:(id)sender {
     [self goToPlayVideoByFilePath:_videoPath];
}

- (IBAction)playTest1:(id)sender {
    [self goToPlayVideoByFilePath:_testOnePath];
}

- (IBAction)playTest2:(id)sender {
    [self goToPlayVideoByFilePath:_testTwoPath];
}

- (IBAction)playTest3:(id)sender {
    [self goToPlayVideoByFilePath:_testThreePath];
}



@end
