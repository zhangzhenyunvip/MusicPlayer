//
//  ZZYLrcCell.h
//  Music
//
//  Created by mac on 15/11/29.
//
//

#import <UIKit/UIKit.h>
@class ZZYLrcLine;
@interface ZZYLrcCell : UITableViewCell

@property (nonatomic, strong) ZZYLrcLine *lrcline;

+ (instancetype)lrcCellWithTableView: (UITableView *)tableView;

@end
