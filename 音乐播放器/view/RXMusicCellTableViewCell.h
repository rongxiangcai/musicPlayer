//
//  RXMusicCellTableViewCell.h
//  音乐播放器
//
//  Created by crx on 15/12/20.
//  Copyright © 2015年 xjhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RXMusic.h"

@interface RXMusicCellTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView andMusicModel:(RXMusic *)music;
@property (nonatomic, strong) RXMusic *music;
@end
