//
//  ZZYLrcCell.m
//  Music
//
//  Created by mac on 15/11/29.
//
//

#import "ZZYLrcCell.h"
#import "ZZYLrcLine.h"

@implementation ZZYLrcCell

+ (instancetype)lrcCellWithTableView: (UITableView *)tableView {
   
    // 定义可冲用表示
    static NSString *reuseId = @"cell";
    // 创建cell
    ZZYLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[ZZYLrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    // 设置cell 的数据
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)setLrcline:(ZZYLrcLine *)lrcline {
    
    _lrcline = lrcline;
    self.textLabel.text = self.lrcline.text;
}

@end
