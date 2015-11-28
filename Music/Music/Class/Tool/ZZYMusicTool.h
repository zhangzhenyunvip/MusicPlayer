//
//  ZZYMusicTool.h
//  Music
//
//  Created by mac on 15/11/27.
//
//

#import <Foundation/Foundation.h>
#import "ZZYMusic.h"

@interface ZZYMusicTool : NSObject



// 获取所有音乐数据
+ (NSArray *)musics;

// 获取正在播放的音乐数据
+ (ZZYMusic *)playingMusic;

// 获取上一首获取
+ (ZZYMusic *)previousMusic;

// 获取下一首
+ (ZZYMusic *)next;

+ (void)setPlayingMusic:(ZZYMusic *)playingMusic;

@end
