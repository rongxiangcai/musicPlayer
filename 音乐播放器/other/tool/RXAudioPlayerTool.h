//
//  RXAudioPlayerTool.h
//  播放音乐的工具类
//
//  Created by crx on 15/12/19.
//  Copyright © 2015年 xjhh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAudioPlayer;

@interface RXAudioPlayerTool : NSObject
/**
 *  播放音乐
 *
 *  @param fileName 歌曲文件名
 */
+ (AVAudioPlayer *)playMusic:(NSString *)fileName;

/**
 *  停止音乐
 *
 *  @param fileName 歌曲文件名
 */
+ (AVAudioPlayer *)stopMusic:(NSString *)fileName;
@end
