//
//  ZZYMusicTool.m
//  Music
//
//  Created by mac on 15/11/27.
//
//

#import "ZZYMusicTool.h"

@implementation ZZYMusicTool

static NSArray *_musics;
static ZZYMusic *_playingMusic;


+ (void)initialize {
    _musics = [ZZYMusic objectArrayWithFilename:@"Musics.plist"];
}

+(NSArray *)musics {
    
    return _musics;
}

+(ZZYMusic *)playingMusic {
    
    return _playingMusic;
}

+ (void)setPlayingMusic:(ZZYMusic *)playingMusic {
    _playingMusic = playingMusic;
}

+ (ZZYMusic *)previousMusic {
    
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    currentIndex--;
    
    if (currentIndex < 0) {
        currentIndex = _musics.count - 1;
    }
    ZZYMusic *previousMusic = _musics[currentIndex];
    _playingMusic = previousMusic;
    return previousMusic;
    
}

+ (ZZYMusic *)next {

    
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    currentIndex++;
    
    if (currentIndex > _musics.count - 1) {
        currentIndex = 0;
    }
    ZZYMusic *nextMusic = _musics[currentIndex];
    _playingMusic = nextMusic;
    return nextMusic;
}

@end
