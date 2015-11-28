//
//  ZZYMusicController.m
//  Music
//
//  Created by mac on 15/11/27.
//
//

#import "ZZYMusicController.h"
#import "ZZYMusicTool.h"

#import "UIImage+Circle.h"
#import "ZZYPlayingController.h"

@interface ZZYMusicController ()
// 所有音乐的数组
//@property (nonatomic, strong) NSArray *musics;

@property (nonatomic, strong) ZZYPlayingController *playingVc;

@end

@implementation ZZYMusicController

#pragma mark - 懒加载
//- (NSArray *)musics {
//    if (_musics == nil) {
//        self.musics = [ZZYMusic objectArrayWithFilename:@"Musics.plist"];
//    }
//    return _musics;
//}

-(ZZYPlayingController *)playingVc {
    if (_playingVc == nil) {
        self.playingVc = [[ZZYPlayingController alloc] init];
    }
    return _playingVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80;

}
#pragma mark - 数据源 和 代理放方法
// 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.让cell 变为不选中状态
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    // 获取到正在放的音乐数据
    ZZYMusic *music = [ZZYMusicTool musics][indexPath.row];
    
    [ZZYMusicTool setPlayingMusic:music];
    
    // 2.跳转控制器
    [self.playingVc show];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ZZYMusicTool musics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"MusicCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ID];
    }
    
    ZZYMusic *music = [ZZYMusicTool musics][indexPath.row];
    
    cell.imageView.image = [UIImage circleImageWithName:music.singerIcon borderWidth:3.0 borderColor:[UIColor purpleColor]];
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    
    return cell;
}



@end
