//
//  ZZYLrcView.m
//  Music
//
//  Created by mac on 15/11/29.
//
//

#import "ZZYLrcView.h"
#import "UIView+AdjustFrame.h"
#import "ZZYLrcCell.h"
#import  "ZZYLrcLine.h"

@interface ZZYLrcView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *lrclines;
@property (nonatomic, strong) NSArray *lrcLines;
@end

@implementation ZZYLrcView 

//-(instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        [self setupTableView];
//    }
//    return self;
//}

-(void)awakeFromNib {
    [super awakeFromNib];
     [self setupTableView];

}

- (void)setupTableView {
    // 创建tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
   
    // 设置代理
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5 , 0, self.tableView.height * 0.5, 0);
}

#pragma mark - 数据源方法 和 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrclines.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZZYLrcCell *cell = [ZZYLrcCell lrcCellWithTableView:tableView];
    
    cell.lrcline = self.lrcLines[indexPath.row];
    
    return cell;
}

// 重写lrcNmae的set方法;
// 解析歌词文件,
-(void)setLrcName:(NSString *)lrcName {
  
    _lrcName = lrcName;
    // 加载歌词
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    NSString *lrcContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 解析歌词
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *lrcLinesStrs = [lrcContent componentsSeparatedByString:@"\n"];
    for (NSString *lrcLineStr in lrcLinesStrs) {
        if ([ lrcLineStr hasPrefix:@"[ti"] || [lrcLineStr hasPrefix:@"[[ar"] || [ lrcLineStr hasPrefix:@"[al"] || ![lrcLineStr hasPrefix:@"["]) {
            continue;
        }
       
        // 截取每一行字符串
        NSArray *lrcLineStrParts = [lrcLineStr componentsSeparatedByString:@"]"];
        
        ZZYLrcLine *lrcLine = [[ZZYLrcLine alloc] init];
        
        lrcLine.text = lrcLineStrParts.lastObject;
        lrcLine.time = [lrcLineStrParts.firstObject substringFromIndex:1];
        
        [tempArray addObject:lrcLine];
    
    }
    self.lrcLines = tempArray;
    // 刷新数据
    [self.tableView reloadData];
}




@end
