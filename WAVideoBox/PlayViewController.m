//
//  PlayViewController.m
//  WAVideoBox
//
//  Created by 黄锐灏 on 2019/1/6.
//  Copyright © 2019 黄锐灏. All rights reserved.
//

#import "PlayViewController.h"
#import <AVKit/AVKit.h>

@interface PlayViewController ()

@property(nonatomic,strong) AVPlayerViewController *playerController;
@property (nonatomic , strong) NSString *filePath;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _playerController = [[AVPlayerViewController alloc] init];
    NSURL * url = [NSURL fileURLWithPath:self.filePath];
    _playerController.player = [AVPlayer playerWithURL:url];
    _playerController.view.frame = self.view.bounds;
    _playerController.showsPlaybackControls = YES;
  
    [self.view addSubview:_playerController.view];
 
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[_playerController player] play];
}

- (void)loadWithFilePath:(NSString *)filePath{
    self.filePath = filePath;
}


@end
