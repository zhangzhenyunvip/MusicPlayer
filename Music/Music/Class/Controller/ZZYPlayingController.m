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
/// 拖拽按钮与左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderLeftConstraint;

@property (weak, nonatomic) IBOutlet UIButton *sliderButton;
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender;

- (IBAction)panslider:(UIPanGestureRecognizer *)sender;
/// 显示时间label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


/// 进度条定时器
@property (nonatomic, strong) NSTimer *progressTimer;
/// 播放器
@property (nonatomic, strong) AVAudioPlayer *player;

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
    
    [self removeProgressTimer];
    
}

#pragma mark - 音乐播放操作
/// 开始播放音乐
- (void) startPlayingMusic {
    
    // 1. 拿到正在播放的音乐数据
    ZZYMusic *music = [ZZYMusicTool playingMusic];
    // 设置界面详细数据
    if (music != self.playingMusic) {
        
        [self addProgressTimer];
    }
        self.playingMusic = music;
        
        self.singerIcon.image = [UIImage imageNamed:music.icon];
        self.singerLabel.text = music.singer;
        self.songLabel.text = music.name;
        
        // 播放音乐
        AVAudioPlayer *player = [ZZYAudioTool playMusicWithName:music.filename];
        self.player = player;
        // 显示总时间的label
        self.totalTimeLabel.text = [self stringWithTime:player.duration];
        
        // 添加定时器
        [self addProgressTimer];
        [self updateInfo];
    
}

/// 停止播放音乐
- (void)stopPlayingMusic {
   // 清楚界面数据
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerLabel.text = nil;
    self.songLabel.text = nil;
    
    // 停止播放音乐
    [ZZYAudioTool stopMusicWithName:self.playingMusic.filename];
    
    // 移除定时器
    [self removeProgressTimer];
}

#pragma mark - 进度条定时器

/// 添加定时器
- (void)addProgressTimer {
    // 创建NSTimer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    self.progressTimer = timer;
    // 添加到运行循环中
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    
}

/// 移除定时器
-(void)removeProgressTimer{
    // 定时器设为无效的
    [self.progressTimer invalidate];
    
    // 定时器清空
    self.progressTimer = nil;
}

/// 定时器监听方法
- (void)updateInfo {
    // 计算当前时间与总时间的比例
    CGFloat progressRation = self.player.currentTime / self.player.duration;
    // 根据比例计算位置
    self.sliderLeftConstraint.constant = progressRation * (self.view.width - self.sliderButton.width);
    // 更新滑块的文字
    NSString *currentTimeStr = [self stringWithTime:self.player.currentTime];
    [self.sliderButton setTitle:currentTimeStr forState:(UIControlStateNormal)];
}

- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender {
    
    // 获取手势的位置
    CGPoint point = [sender locationInView:sender.view];
    
    // 更新sliderButton的约束
    if (point.x <= self.sliderButton.width * 0.5) {
        self.sliderLeftConstraint.constant = 0;
    } else if (point.x >= self.view.width - self.sliderButton.width * 0.5) {
        self.sliderLeftConstraint.constant =  self.view.width - self.sliderButton.width * 0.5;
    } else {
        self.sliderLeftConstraint.constant = point.x - self.sliderButton.width * 0.5 - 1;
    }
    
    // 改变当前播放的时间
    CGFloat progressRotaion = self.sliderLeftConstraint.constant / (self.view.width - self.sliderButton.width);
    CGFloat currentTime = progressRotaion * self.player.duration;
    self.player.currentTime = currentTime;
    // 更新文字
    [self updateInfo];
    
}

- (IBAction)panslider:(UIPanGestureRecognizer *)sender {
    
    // 获取拖拽手势位移
    CGPoint point = [sender translationInView:sender.view];
   
    /// 每次加的是位移的增量,而不是位移总量,把位移清零
    [sender setTranslation:CGPointZero inView:sender.view];
    
    // 更新sliderButton的位置
    if (self.sliderLeftConstraint.constant + point.x <= 0) {
        self.sliderLeftConstraint.constant = 0;
    } else if (self.sliderLeftConstraint.constant + point.x >= self.view.width - self.sliderButton.width) {
        self.sliderLeftConstraint.constant = self.view.width - self.sliderButton.width ;
    } else {
        self.sliderLeftConstraint.constant += point.x;
    }
    
    // 改变当前播放的时间
    CGFloat progressRation = self.sliderLeftConstraint.constant / (self.view.width - self.sliderButton.width);
    CGFloat curretnTime = progressRation * self.player.duration;
    
    
    // 更新文字
    NSString *curretTimeStr = [self stringWithTime:curretnTime];
    
    [self.sliderButton setTitle:curretTimeStr forState:(UIControlStateNormal)];
    self.timeLabel.text = curretTimeStr;
    
    // 监听拖拽手势状态
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self removeProgressTimer];
        self.timeLabel.hidden = NO;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        self.player.currentTime = curretnTime;
        [self addProgressTimer];
        self.timeLabel.hidden = YES;
    }
    
}


#pragma mark - 处理时间的label
- (NSString *)stringWithTime:(NSTimeInterval )time {
    
    NSInteger minute = time / 60;
    NSInteger second =(NSInteger) time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
}




@end
