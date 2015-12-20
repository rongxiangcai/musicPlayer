//
//  RXMusic.h
//  音乐播放器
//
//  Created by crx on 15/12/19.
//  Copyright © 2015年 xjhh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RXMusic : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *singerIcon;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@end
