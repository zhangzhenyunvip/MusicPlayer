//
//  ZZYAudioTool.m
//  Music
//
//  Created by mac on 15/11/28.
//
//

#import "ZZYAudioTool.h"


@implementation ZZYAudioTool

static NSMutableDictionary *_musics;

+(void)initialize {
    _musics = [NSMutableDictionary dictionary];
}

+(AVAudioPlayer *)playMusicWithName:(NSString *)musicName {
    
    assert(musicName);
    
    // 1. 根据音乐数据取出播放器
    AVAudioPlayer *player = _musics[musicName];
    // 2. 设置播放器的数据
    if (player == nil) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [player prepareToPlay];
        _musics[musicName] = player;
    }
    // 3. 播放音乐
    [player play];
    return player;
}

+(void)pauseMusicWithName:(NSString *)musicName {
    
    // 0.判断musicName是否为空
    assert(musicName);
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    if (player) {
        [player pause];
    }
}

+(void)stopMusicWithName:(NSString *)musicName {

    // 判断是否为空
    assert(musicName);
    // 取出播放器
    AVAudioPlayer *player = _musics[musicName];
    // 暂停
    if (player) {
        [player pause];
        // 移除播放器
         NSLog(@"%@",player);
        player = nil;
       
    }
}

@end
