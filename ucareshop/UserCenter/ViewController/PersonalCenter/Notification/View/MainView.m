//
//  MainView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import "MainView.h"
#import "MainTableViewCell.h"
#import "URLRequest.h"
#import "PrefixHeader.pch"

#import "MainViewModel.h"
#import "MessageModel.h"
#import "MainTableContentCell.h"
#import "MainTableModel.h"
#import <Masonry/Masonry.h>
#import <Masonry.h>

@interface MainView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) URLRequest *urlRequest;
@property (nonatomic) NSInteger messageNumber;
@property (strong,nonatomic) NSMutableArray *listMessage;
@property (strong,nonatomic) MainTableViewCell *cell;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MainView //(最上级）

#pragma mark - Life Cycle
- (instancetype)initWithDelegate:(id)delegate viewModel:(MainViewModel *)viewModel {
    
    self = [super init];
    
    if (self) {
        [self setupSubViews];
        self.listMessage = [NSMutableArray array];
        _delegate = delegate;
        _mainViewModel = viewModel;
    }
    
    return self;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listMessage.count;//多个大单元格
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;//1个小单元格
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    if (self.indexPath && self.indexPath.row == indexPath.row && self.indexPath.section == indexPath.section) {//判断是否是选中行
        NSInteger textHeight = 60;// 高度要动态计算
        return 70 + textHeight;//展开（整的，包括中级和下级）
    } else {
        return 70;//折叠
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indexPath && self.indexPath.row == indexPath.row && self.indexPath.section == indexPath.section) {
        // 如果选中的行存在并且选中的行于当前行一致就清空选中状态，刷新数据
        self.indexPath = nil;//选中行设置为空，未选中状态，大单元格点击产生折叠效果
        [self.mainTableView reloadData];
    } else {
        // 如果没有选中行就标记选中行刷新数据
        self.indexPath = indexPath;//选中，产生展开效果
        [self.mainTableView reloadData];
    }
    MessageModel *messageModel = [self.listMessage objectAtIndex:indexPath.section];
    if (messageModel.readStatus == 2)
    {
        [self setMessageHadRead:messageModel];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
       self.cell = [MainTableViewCell  cellWithTableView:tableView];//中级View
    __weak MainView *weakSelf = self;
    self.cell.onSelectCell = ^(NSIndexPath * _Nonnull indexPath) {//来自中级的indexPath
        if (weakSelf.indexPath && weakSelf.indexPath.row == indexPath.row && weakSelf.indexPath.section == indexPath.section) {
            weakSelf.indexPath = nil;
            [weakSelf.mainTableView reloadData];
        }
        

        MessageModel *model = [weakSelf.listMessage objectAtIndex:indexPath.section];
        if (model.readStatus == 2)
        {
            [weakSelf setMessageHadRead:model];
        }
    };
    
    self.cell.indexPath = indexPath;//为中级的indexPath赋予值
    //设置中级的选中行与否
    if (self.indexPath && self.indexPath.row == indexPath.row && self.indexPath.section == indexPath.section) {
        self.cell.isSeletedRow = YES;
    } else {
        self.cell.isSeletedRow = NO;
    }
    //取得model数据接口，并赋值给messageModel
    MessageModel *messageModel = [self.listMessage objectAtIndex:indexPath.section];
    self.cell.messageModel = messageModel;

    return self.cell;
}

#pragma mark - Private Method
- (void)setupSubViews {
    self.mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    [self addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            
        } else {
            make.edges.equalTo(self);
        }
    }];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.mainTableView.alwaysBounceVertical = YES;
    self.refreshControl.tintColor = [UIColor grayColor];
    //下拉刷新
    [self.refreshControl addTarget:self action:@selector(getDataList) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview:self.refreshControl];
}

- (void)setMessageHadRead:(MessageModel*)messageModel
{
    //设置消息为已读
    URLRequest *urlRequestForReadInfo = [[URLRequest alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    NSString *messageID = [NSString stringWithFormat:@"%ld",(long)messageModel.messageId];
    [tempDict setValue:messageID forKey:@"messageId"];
    __weak MainView *weakSelf = self;
    urlRequestForReadInfo.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1)
        {
            //接口处上传已经修改，在本地修改数据源，刷新后就能正常显示
            messageModel.readStatus = 1;
            [weakSelf.mainTableView reloadData];
        }
        else
        {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [urlRequestForReadInfo startRequest:tempDict pathUrl:@"/message/setMessageRead"];
}

//上一级使用可以直接调用这个方法
- (void)getDataList //数据请求接口
{
    self.urlRequest = [[URLRequest alloc] init];
    //设置消息为已读 -- 从数据库获取消息内容
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:@"3" forKey:@"memberId"];
    __weak typeof(self) weakSelf = self;
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1)
        {
            NSDictionary *contentDict = content[@"content"];
            NSArray *messArray = contentDict[@"re"];
            //放在外边的话，块是赋值语句，listMessage未赋值为空
            for (NSDictionary *dict in messArray)
            {
                //获得值
                MessageModel *messageModel = [[MessageModel alloc]init];
                NSInteger messageId = [dict[@"id"] integerValue];
                NSString *content = dict[@"content"];
                NSString *createTime = dict[@"createTime"];
                NSInteger readStatus = [dict[@"isRead"] integerValue];
                //添加到数组
                messageModel.messageId = messageId;
                messageModel.content = content;
                messageModel.createTime = createTime;
                messageModel.readStatus = readStatus;
                //将model添加到最高级的listMessage数组里
                [weakSelf.listMessage addObject:messageModel];
            }
            [weakSelf.mainTableView reloadData];
            [weakSelf.refreshControl endRefreshing];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/message/getMessageList"];
}
@end
