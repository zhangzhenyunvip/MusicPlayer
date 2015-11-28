//
//  ZZYAudioTool.h
//  Music
//
//  Created by mac on 15/11/28.
//
//

#import <Foundation/Foundation.h>

@interface ZZYAudioTool : NSObject

/// 播放音乐

+ (void)playMusicWithName:(NSString *)name;

/// 暂停音乐

+ (void)pauseMusicWithName:(NSString *)name;

/// 停止播放音乐

+ (void)stopMusicWithName:(NSString *)name;


@end
