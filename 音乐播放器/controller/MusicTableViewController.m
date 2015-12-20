//
//  MusicTableViewController.m
//  音乐播放器
//
//  Created by crx on 15/12/19.
//  Copyright © 2015年 xjhh. All rights reserved.
//

#import "MusicTableViewController.h"
#import "MJExtension.h"
#import "RXMusic.h"
#import <AVFoundation/AVFoundation.h>
#import "RXAudioPlayerTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RXMusicCellTableViewCell.h"


static NSString *ID = @"music";
@interface MusicTableViewController () <AVAudioPlayerDelegate>
//音乐模型数组
@property (nonatomic, strong) NSArray *musics;
@property (nonatomic, strong) AVAudioPlayer *currentPlayingPlayer;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) NSIndexPath *playingIndexPath;
- (IBAction)nextSong:(UIBarButtonItem *)sender;
@end

@implementation MusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"音乐播放器";
    
    
}

- (CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(musicTimeChange)];
    }
    return _link;
}

/**
 *  播放下一首歌曲
 *
 *  @param sender
 */
- (IBAction)nextSong:(UIBarButtonItem *)sender {
    if (self.playingIndexPath == nil) {
        self.playingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:self.playingIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.tableView didSelectRowAtIndexPath:self.playingIndexPath];
    }else{
        [self tableView:self.tableView didDeselectRowAtIndexPath:self.playingIndexPath];
        [self audioPlayerDidFinishPlaying:self.currentPlayingPlayer successfully:YES];
    }
    
}

- (NSArray *)musics{
    if (_musics==nil) {
        _musics = [RXMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return  _musics;
}

- (void)musicTimeChange{
    NSLog(@"%f---%f",self.currentPlayingPlayer.duration, self.currentPlayingPlayer.currentTime);
    
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.musics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RXMusic *music = self.musics[indexPath.row];
    RXMusicCellTableViewCell *cell = [RXMusicCellTableViewCell cellWithTableView:tableView andMusicModel:music];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.playingIndexPath = indexPath;
    
    RXMusic *music = self.musics[indexPath.row];
    music.playing = YES;
    AVAudioPlayer *player =  [RXAudioPlayerTool playMusic:music.filename];
    self.currentPlayingPlayer = player;
    player.delegate = self;
    
    //开启定时器监听播放器进度
    [self.link invalidate];
    self.link = nil;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    // 在锁屏界面显示歌曲信息
    [self showInfoInLockedScreen:music];
    
    //再次传递模型
    RXMusicCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.music = music;
    
    
}

/**
 *  在锁屏界面显示歌曲信息
 */
- (void)showInfoInLockedScreen:(RXMusic *)music
{
    //    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 标题(音乐名称)
    info[MPMediaItemPropertyTitle] = music.name;
    
    // 作者
    info[MPMediaItemPropertyArtist] = music.singer;
    
    // 专辑
    info[MPMediaItemPropertyAlbumTitle] = music.singer;
    
    // 图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:music.icon]];
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    RXMusic *music = self.musics[indexPath.row];
    music.playing = NO;
    [RXAudioPlayerTool stopMusic:music.filename];
    
    //再次传递模型
    RXMusicCellTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.music = music;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //播放下一首歌曲
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    long nextRow = selectedIndexPath.row + 1;
    if (nextRow == self.musics.count) {
        nextRow = 0;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextRow inSection:selectedIndexPath.section];
    [self.tableView selectRowAtIndexPath:nextIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:nextIndexPath];
}




@end
