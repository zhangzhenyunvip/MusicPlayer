//
//  ZZYPlayingController.m
//  Music
//
//  Created by mac on 15/11/27.
//
//
#import <AVFoundation/AVFoundation.h>

#import "ZZYPlayingController.h"
#import "UIView+AdjustFrame.h"
#import "ZZYMusicTool.h"
#import "ZZYAudioTool.h"


@interface ZZYPlayingController ()
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;


/// 正在播放的音乐
@property (nonatomic, strong) ZZYMusic *playingMusic;
@end

@implementation ZZYPlayingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)show {
    // 0.判断播放音乐是否发生改变
    if (self.playingMusic && self.playingMusic != [ZZYMusicTool playingMusic]) {
        [self stopPlayingMusic];
    }
    
    // 1.获取weindow
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 2.设置view
    self.view.frame = window.bounds;
    window.userInteractionEnabled = NO;
    [window addSubview:self.view];

    // 添加动画
    self.view.y = self.view.height;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = 0;
    }completion:^(BOOL finished) {
        
        window.userInteractionEnabled = YES;
        // 开始播放音乐
        [self startPlayingMusic];
    }];
}

// 退出控制器
- (IBAction)exit {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
    // 添加动画
    [UIView animateWithDuration:1.0 animations:^{
        self.view.y = self.view.height;
    }completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

#pragma mark - 音乐播放操作
/// 开始播放音乐
- (void) startPlayingMusic {
    
    // 1. 拿到正在播放的音乐数据
    ZZYMusic *music = [ZZYMusicTool playingMusic];
    // 设置界面详细数据
    if (music != self.playingMusic) {
        self.playingMusic = music;
        
        self.singerIcon.image = [UIImage imageNamed:music.icon];
        self.singerLabel.text = music.singer;
        self.songLabel.text = music.name;
        
        // 播放音乐
        AVAudioPlayer *player = [ZZYAudioTool playMusicWithName:music.filename];
        
        // 显示总时间的label
        self.totalTimeLabel.text = [self stringWithTime:player.duration];
    }
    
}

/// 停止播放音乐
- (void)stopPlayingMusic {
   // 清楚界面数据
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerLabel.text = nil;
    self.songLabel.text = nil;
    
    // 停止播放音乐
    [ZZYAudioTool stopMusicWithName:self.playingMusic.filename];
}

#pragma mark - 处理时间的label
- (NSString *)stringWithTime:(NSTimeInterval )time {
    
    NSInteger minute = time / 60;
    NSInteger second =(NSInteger) time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
}


@end
