//
//  RXAudioPlayerTool.m
//  音乐播放器
//
//  Created by crx on 15/12/19.
//  Copyright © 2015年 xjhh. All rights reserved.
//

#import "RXAudioPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
static NSMutableDictionary *_audioPlayerDict;
@implementation RXAudioPlayerTool

+ (void)initialize{
    _audioPlayerDict = [NSMutableDictionary dictionary];
    //设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //AVAudioSessionCategorySoloAmbient播放歌曲时停止其他的播放
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
}

/**
 *  播放音乐
 *
 *  @param fileName 歌曲文件名
 */
+ (AVAudioPlayer *)playMusic:(NSString *)fileName{
    AVAudioPlayer *player = _audioPlayerDict[fileName];
    if (!player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _audioPlayerDict[fileName] = player;
    }
    [player prepareToPlay];
    if (![player isPlaying]) {
        [player play];
    }
    return player;
}

/**
 *  停止音乐
 *
 *  @param fileName 歌曲文件名
 */
+ (AVAudioPlayer *)stopMusic:(NSString *)fileName{
    AVAudioPlayer *player = _audioPlayerDict[fileName];
    if (player) {
        if ([player isPlaying]) {
            [player stop];
            [_audioPlayerDict removeObjectForKey:fileName];
        }
    }
    return player;
}
@end
