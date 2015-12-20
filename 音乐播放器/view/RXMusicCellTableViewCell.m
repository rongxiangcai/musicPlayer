//
//  RXMusicCellTableViewCell.m
//  音乐播放器
//
//  Created by crx on 15/12/20.
//  Copyright © 2015年 xjhh. All rights reserved.
//

#import "RXMusicCellTableViewCell.h"
#import "RXMusic.h"
#import "UIImage+MJ.h"
#import "Colours.h"
static NSString *ID = @"music";

@interface RXMusicCellTableViewCell()
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation RXMusicCellTableViewCell

- (CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeSomething)];
    }
    return _link;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView andMusicModel:(RXMusic *)music{
    RXMusicCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[RXMusicCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.music = music;
    return cell;
}

- (void)setMusic:(RXMusic *)music{
    _music = music;
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
    
    self.detailTextLabel.textColor = [UIColor blackColor];
    self.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:2 borderColor:[UIColor skyBlueColor]];
    
    if (music.isPlaying) {
        //开始动画
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }else{
        //停止动画
        [self.link invalidate];
        self.link = nil;
        self.imageView.transform = CGAffineTransformIdentity;
    }
}

- (void)changeSomething{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI_4/60);
}


@end
