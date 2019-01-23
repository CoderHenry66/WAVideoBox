# WAVideoBox

https://github.com/CoderHenry66/WAVideoBox

秒级! 三行代码实现iOS视频压缩、变速、混音、合并、水印、旋转、换音、裁剪 ! 支持不同分辩率，支持你能想到的各种混合操作!

======================

WAVideoBox是一款基于AVFoundation视频操作框架，用短短几行代码就可完成各种简单及至复杂的视频操作命令。使用简单，性能高超~

尤其是不同分辩率视频的组合操作，如，给A视频变速，给B视频加水印，把C视频旋转...把ABC..视频合并，再操作合并视频...循环...
用WAVideoBox能快速高效实现上述功能。

PS ：支持多线程处理

iOS 8.0 ++

使用指导
=====================

常规操作: append一个视频 + 操作命令 + finish

组合操作：将所有视频append，操作命令 * n，finish

骚操作：参照文尾

下列代码均跑于6s 12.0系统

常规操作: 三行代码
=====================

// 压缩:将19秒的视频进行压缩，  耗时<1秒, 成果 : 6.7M -> 335KB (有损压缩，高清压缩可设置ratio  videoQuality)
    
    // 第一种：自动压缩，分low ,medium , high 三档
    [_videoBox appendVideoByPath:_videoPath];
    _videoBox.ratio = WAVideoExportRatioLowQuality;//有损压缩
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        // do it
    }];
    
    // 第二种：通过自行设定分辩率，实现高清压缩
    [_videoBox appendVideoByPath:_videoPath];
    _videoBox.ratio = WAVideoExportRatio640x480;
        // _videoBox.vidoQuality = 6;还可以通过设置videoQuality进行精准压缩
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        // do it
    }];
        
![压缩](http://g.recordit.co/FLVh4VqcrI.gif)        
        
// 拼接:将两个不同分辨率视频拼接（17秒的视频），  耗时<3秒 ，如果是相同分辩率的视频耗时<1秒

    [_videoBox appendVideoByPath:_testThreePath];
    [_videoBox appendVideoByPath:_testTwoPath];
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        // do it
    }];
    
// 混音:给视频混上其他视频/音乐的声音 （19秒视频）, 耗时 < 1秒

    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox dubbedSoundBySoundPath:_testThreePath];
    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
        // do it 
    }];
    
// 旋转、裁剪、换音、变速、水印....更多操作见demo

组合操作 
=====================

//  将1号拼接到video，用2号的音频替换，给视频加一个水印，旋转180度，混上3号的音,速度加快两倍
//  把生好的视频裁6-12秒，压缩
//  耗时 < 2秒

    [_videoBox appendVideoByPath:_videoPath];
    [_videoBox appendVideoByPath:_testThreePath];
    [_videoBox replaceSoundBySoundPath:_testTwoPath];
    [_videoBox appendWaterMark:[UIImage imageNamed:@"waterMark"] relativeRect:CGRectMake(0.7, 0.7, 0.2, 0.1)];

    [_videoBox rotateVideoByDegress:180];
    [_videoBox dubbedSoundBySoundPath:_testOnePath];
    [_videoBox gearBoxWithScale:2];

    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(CMTimeMake(2400, 600), CMTimeMake(3600, 600))];

    [_videoBox asyncFinishEditByFilePath:filePath complete:^(NSError *error) {
            // do it
    }];

骚操作 
=====================

// 放入原视频，换成1号的音，再把3号视频放入混音,剪其中8秒
// 拼1号视频，给1号水印,剪其中8秒
// 拼2号视频，给2号变速
// 拼3号视频，旋转180,剪其中8秒
// 把最后的视频再做一个变速
// 耗时<3秒，如果都是分辩率一致的视频，将更快

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
            // do it
    }];
    
![骚操作](http://recordit.co/euSAMGzK0P.gif)   

Box分析
=====================

    PS:为了灵活的调用、任意使用,效果与代码的调用顺序有关
    比如先变速，再换音轨，明显后面才换的音轨不会有变速效果

    WAVideoBox的工作区域:
    ----缓存区,appedVideo后缓存区域
    ----工作区,视频指令区域，只有在这区域的视频才是有效操作
    ----合成区,完成视频指令后待合成区域

    1､appendVideo:会将视频加入到缓存区，将工作区内容合成一个视频（无法再拆散）,并移到合成区，清空工作区
    2､视频操作指令:缓存区视频放到工作区，视频操作只对工作区视频有效
    3､commit:合成区域，将缓存区，合成区的视频移到工作区,视频操作对所有视频有效

    tip:线程安全，适用于短视频处理



