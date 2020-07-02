//
//  MainTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import "MainTableViewCell.h"
#import "MainTableContentCell.h"
#import "PrefixHeader.pch"
#import "URLRequest.h"
#import <Masonry/Masonry.h>

@interface MainTableViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *labelTitle;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, copy) NSArray *arrayTableDatas;

@property (nonatomic, assign) BOOL isSelected;


//数据库
@property (nonatomic, strong) URLRequest *urlRequest;
@property (nonatomic) NSInteger messageNumber;

@property (nonatomic, strong) NSArray *listMessage;
@property (nonatomic) NSMutableArray *messageId;
@property (nonatomic) NSMutableArray *createTime;
@property (nonatomic) NSMutableArray *readStatus;

@property (nonatomic) NSInteger statusCode;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSInteger memberId;



@end

@implementation MainTableViewCell

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//只1节，嵌套的table
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.isSeletedRow ? 1 : 0;//选中有1个展开，未选中为0
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;//展开的话其高度
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MainTableContentCell *cell = [MainTableContentCell cellWithTableView:tableView];//最低级view
    
    cell.labelTitle.text = self.messageModel.content;//展开的内容

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSeletedRow) {//这行肯定被选中了
        self.isSeletedRow = NO;//将其设置为未选中状态
    }
    if (self.onSelectCell) {//代码块将中级的indexpath
        self.onSelectCell(self.indexPath);//传给最高级
    }
}

#pragma mark - Event Response
- (void)onBtnTappedEvent:(UIButton *)btn {
   
}

#pragma mark - Private Method
- (void)setViewWithModel:(id)model {
    if (model && [model isKindOfClass:[NSArray class]]) {
        self.arrayTableDatas = model;
        
        [self.mainTableView reloadData];
    }
}

- (void)setupSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
    }];
    [contentView setViewLayerShadow];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@70);
    }];
    
    //时间
    self.topTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.topTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.topTimeLabel.textColor = [UIColor grayColor];
    [topView addSubview:self.topTimeLabel];
    [self.topTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    self.bottomTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.bottomTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.bottomTimeLabel.textColor = [UIColor grayColor];
    [topView addSubview:self.bottomTimeLabel];
    [self.bottomTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.top.equalTo(self.topTimeLabel.mas_bottom).offset(5);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    
    //圆点
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.frame = CGRectMake(30, 30, 10, 10);
    self.maskLayer.cornerRadius = 5;
    self.maskLayer.backgroundColor = [UIColor redColor].CGColor;
    [topView.layer addSublayer:self.maskLayer];
    
    
    
    
    //未读消息点击按钮
    self.buttonOpen = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonOpen setTitleColor:kRGBAlpha(178, 178, 178, 1) forState:UIControlStateNormal];
    [self.buttonOpen.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.buttonOpen addTarget:self action:@selector(onBtnTappedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonOpen setImage:[UIImage imageNamed:@"ic_home_open"] forState:UIControlStateNormal];
    [topView addSubview:self.buttonOpen];
    [self.buttonOpen makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(40);
        make.size.equalTo(CGSizeMake(100, 30));
        make.centerY.equalTo(0);
    }];
    self.buttonOpen.userInteractionEnabled = NO;
    [self.buttonOpen setTitleRightSpace:5];
    [contentView addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.equalTo(0);
    }];
}

#pragma mark - Setter & Getter
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.scrollEnabled = NO;
        _mainTableView.separatorColor = kRGBAlpha(0, 0, 0, 0.1);
    }
    
    return _mainTableView;
}

//NSString转NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}
//获取消息
- (void)requestForMessage:(NSIndexPath *)indexPath {
    
    self.listMessage = [[NSArray alloc] init];
    self.messageId = [[NSMutableArray alloc] init];
    self.content = [[NSMutableArray alloc] init];
    self.createTime = [[NSMutableArray alloc] init];
    self.readStatus = [[NSMutableArray alloc] init];
    self.urlRequest = [[URLRequest alloc] init];
    
    //设置消息为已读 -- 从数据库获取消息内容
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:@"3" forKey:@"memberId"];
    __weak MainTableViewCell *weakSelf = self;
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSDictionary *contentDict = content[@"content"];
            weakSelf.listMessage = contentDict[@"re"];
            //放在外边的话，块是赋值语句，listMessage未赋值为空
            for (NSDictionary *dict in weakSelf.listMessage) {
                //获得值
                NSInteger messageId = [dict[@"id"] integerValue];
                NSString *content = dict[@"content"];
                NSString *createTime = dict[@"createTime"];
                NSInteger readStatus = [dict[@"isRead"] integerValue];
                //添加到数组
                [weakSelf.messageId addObject:@(messageId)];
                [weakSelf.content addObject:content];
                [weakSelf.createTime addObject:createTime];
                [weakSelf.readStatus addObject:@(readStatus)];
            }

            [weakSelf.mainTableView reloadData];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/message/getMessageList"];
}


- (void)getDataList
{
    self.listMessage = [[NSArray alloc] init];
    self.messageId = [[NSMutableArray alloc] init];
    self.content = [[NSMutableArray alloc] init];
    self.createTime = [[NSMutableArray alloc] init];
    self.readStatus = [[NSMutableArray alloc] init];
    self.urlRequest = [[URLRequest alloc] init];
    
    //设置消息为已读 -- 从数据库获取消息内容
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:@"3" forKey:@"memberId"];
    __weak MainTableViewCell *weakSelf = self;
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1)
        {
            NSDictionary *contentDict = content[@"content"];
            weakSelf.listMessage = contentDict[@"re"];
            //放在外边的话，块是赋值语句，listMessage未赋值为空
            for (NSDictionary *dict in weakSelf.listMessage)
            {
                //获得值
                NSInteger messageId = [dict[@"id"] integerValue];
                NSString *content = dict[@"content"];
                NSString *createTime = dict[@"createTime"];
                NSInteger readStatus = [dict[@"isRead"] integerValue];
                //添加到数组
                [weakSelf.messageId addObject:@(messageId)];
                [weakSelf.content addObject:content];
                [weakSelf.createTime addObject:createTime];
                [weakSelf.readStatus addObject:@(readStatus)];
            }
            [weakSelf.mainTableView reloadData];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/message/getMessageList"];
}

- (void)setMessageModel:(MessageModel *)messageModel //Model的Set方法，及时更新值
{
    _messageModel = messageModel;//中级的model拿到值
    //显示日期
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [[NSDate alloc] init];
    NSString *timeString = [NSString stringWithFormat:@"%@",messageModel.createTime];
    date1 = [self dateFromString:timeString];
    self.topTimeLabel.text = [dateFormatter1 stringFromDate:date1];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = @"HH:mm:ss";
    NSDate *date2 = [[NSDate alloc] init];
    date2 = [self dateFromString:timeString];
    self.bottomTimeLabel.text = [dateFormatter2 stringFromDate:date2];
    //红点
    NSInteger readStatus = messageModel.readStatus;//消失
//    NSLog(@"%@----%ld",messageModel.content,(long)messageModel.readStatus);
    if (readStatus == 2)
    {
        [self.buttonOpen setTitle:@"未读消息" forState:UIControlStateNormal];
        self.maskLayer.hidden = NO;
    }
    else
    {
        [self.buttonOpen setTitle:@"已读消息" forState:UIControlStateNormal];
        self.maskLayer.hidden = YES;
    }
    [self.mainTableView reloadData];//UI更新了，都需要执行这个方法
}
@end
