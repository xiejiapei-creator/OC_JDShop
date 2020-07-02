//
//  CommentView.m
//  ucareshop
//
//  Created by liushuting on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CommentView.h"
#import "StarView.h"
#import "CommentBottomContentCell.h"
#import "CommentContentModel.h"
#import <ChameleonFramework/Chameleon.h>
#import "URLRequest.h"
#import "ToastView.h"
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

static NSString *cellIndentifier = @"commentCell";

#pragma mark - 枚举

@interface CommentView ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UIView *sectionHeaderView;
@property (nonatomic, strong, readwrite) UILabel *commentTitle;
@property (nonatomic, strong, readwrite) UILabel *commentScore;
@property (nonatomic, strong, readwrite) UIView *commentResult;
@property (nonatomic, strong, readwrite) UILabel *totalPoint;
@property (nonatomic, strong, readwrite) UILabel *commentNumber;
@property (nonatomic, strong, readwrite) UILabel *commentTheme;
@property (nonatomic, strong, readwrite) UIView *separator;
@property (nonatomic, strong, readwrite) UIView *separatorComment;
@property (nonatomic, assign, readwrite) NSInteger tapStarNumber;
@property (nonatomic, assign, readwrite) CGFloat starViewHeight;
@property (nonatomic, assign, readwrite) CGFloat starViewWidth;
@property (nonatomic, assign, readwrite) CGFloat commentContentHeight;
@property (nonatomic, strong, readwrite) UITableView *commentContentTable;
@property (nonatomic, strong, readwrite) NSArray <CommentContentModel *> * commentContentData;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) ToastView *toast;
@end

@implementation CommentView


#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self createSubViewsConstraints];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

#pragma mark - Events

- (void) createCommentAnimated {
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.commentContentTable.sectionHeaderHeight = 300.0;
    } completion:nil];
}

- (CGRect) calculateHeightOfText : (UILabel *) textLabel{
    // 参数1: 自适应尺寸,提供一个宽度,去自适应高度
    // 参数2:自适应设置 (以行为矩形区域自适应,以字体字形自适应)
    // 参数3:文字属性,通常这里面需要知道是字体大小
    // 参数4:绘制文本上下文,做底层排版时使用,填nil即可
    //上面方法在计算文字高度的时候可能得到的是带小数的值,如果用来做视图尺寸的适应的话,需要使用更大一点的整数值.取整的方法使用ceil函数
    //    return height + ceil(infoRect.size.height);
    NSString *content = textLabel.text;
    CGSize infoSize = CGSizeMake(self.bounds.size.width - 20, 1000);
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
    CGRect size =[content boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return size;
}

- (void)gotoWriteComment {
    self.isHidden = YES;
    self.status(self.isHidden);
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize viewSize = self.bounds.size;
    
    self.sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 0)];
    self.sectionHeaderView.backgroundColor = UIColor.whiteColor;
    
    self.commentTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentTitle.textAlignment = NSTextAlignmentLeft;
    self.commentTitle.font = [UIFont boldSystemFontOfSize:25];
    self.commentTitle.text = @"评分及评论";
    [self.sectionHeaderView addSubview:self.commentTitle];
    
    self.commentScore = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentScore.textAlignment = NSTextAlignmentCenter;
    self.commentScore.font = [UIFont boldSystemFontOfSize:25];//加粗
    self.commentScore.textColor = [UIColor colorWithHexString:@"#6f6f6f"];
    self.commentScore.text = [NSString stringWithFormat:@"%@%@", self.scoreNumber, @"分"];
    [self.sectionHeaderView addSubview:self.commentScore];
//
    self.commentResult = [[UIView alloc]initWithFrame:CGRectZero];
    [self.sectionHeaderView addSubview:self.commentResult];
    self.totalPoint = [[UILabel alloc]initWithFrame:CGRectZero];
    self.totalPoint.textColor = [UIColor colorWithHexString:@"#6f6f6f"];
    self.totalPoint.textAlignment = NSTextAlignmentCenter;
    self.totalPoint.font = [UIFont systemFontOfSize:15];
    self.totalPoint.text = @"满分5分";
    [self.sectionHeaderView addSubview:self.totalPoint];

    self.commentNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentNumber.textColor = [UIColor colorWithHexString:@"#6f6f6f"];
    self.commentNumber.textAlignment = NSTextAlignmentCenter;
    self.commentNumber.font = [UIFont systemFontOfSize:15];
    self.commentNumber.text = [NSString stringWithFormat:@"%@%@", self.totalNumber, @"条评论"];
    [self.sectionHeaderView addSubview:self.commentNumber];
    
    self.separator = [[UIView alloc]initWithFrame:CGRectZero];
    self.separator.backgroundColor = UIColor.lightGrayColor;
    [self.sectionHeaderView addSubview:self.separator];
    
    self.separatorComment = [[UIView alloc]initWithFrame:CGRectZero];
    self.separatorComment.backgroundColor = UIColor.lightGrayColor;
    [self.sectionHeaderView addSubview:self.separatorComment];
    
    self.commentTheme = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentTheme.textAlignment = NSTextAlignmentCenter;
    self.commentTheme.font = [UIFont systemFontOfSize:20];
    self.commentTheme.text = @"商品评论";
    [self.sectionHeaderView addSubview:self.commentTheme];
    [self drawLine];
    [self sectionHeaderConstrains];
    return self.sectionHeaderView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取后端接口的text的值，根据不同的值h改变cell的高度
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectZero];
    text.text = @"vwuiegvuwigviuwevguwievguiwvgwuievgwoeuvgowugvwougwuoegwcguwgvvgwvgvwugwvgwu";
    self.commentContentHeight = [self calculateHeightOfText:text].size.height + 80;
    return self.commentContentHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentContentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentBottomContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    CommentContentModel *data = self.commentContentData[indexPath.row];
    cell.commentTopic.text = data.commentTopic;
    cell.commentData.text = data.commentDate;
    cell.commentContent.text = data.commentContent;
    cell.userName.text = data.userName;
    cell.star.starWithColorNumber = data.starNumber;
    [cell.star updateLayout];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITextFieldDelegate

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.status = ^(BOOL maskStatus) {};
    self.starNumber = ^(int starNumber) {};
    self.urlRequest = [URLRequest new];
    self.commentContentTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.commentContentTable registerClass:[CommentBottomContentCell class] forCellReuseIdentifier:cellIndentifier];
    self.commentContentTable.delegate = self;
    self.commentContentTable.dataSource = self;
    self.commentContentTable.backgroundColor = UIColor.whiteColor;
    self.commentContentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.commentContentTable];
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = UIColor.clearColor;
    self.toast.userInteractionEnabled = NO;
    [self addSubview:self.toast];
}

// 添加约束
- (void)createSubViewsConstraints {
    
    [self.commentContentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
    }];
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (void) createCommentContentData : (NSString *) commodityId{
    __weak CommentView *weakself = self;
    if ([commodityId isKindOfClass:[NSNull class]] ||[[NSString stringWithFormat:@"%@", commodityId] isEqualToString:@""]||[[NSString stringWithFormat:@"%@", commodityId] isEqualToString:@"0"]) {
        
    } else {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        NSMutableArray *mutableData = [NSMutableArray array];
        [temp setObject:[NSString stringWithFormat:@"%@", commodityId] forKey:@"id"];
        self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
            if ([str isEqualToString:@"1"]) {
                for (NSDictionary *dict in content[@"content"][@"re"][@"commentDTOList"]) {
                    CommentContentModel *commentContent = [CommentContentModel new];
                    commentContent.commentContent = dict[@"content"];
                    commentContent.commentDate = dict[@"createTime"];
                    commentContent.userName = dict[@"memberNickName"];
                    commentContent.commentTopic = dict[@"goosPropertyName"];
                    if ([dict[@"goodsScore"] isKindOfClass:[NSNull class]]) {
                        commentContent.starNumber = 0;
                    } else {
                        commentContent.starNumber = [dict[@"goodsScore"] intValue];
                    }
                    [mutableData addObject:commentContent];
                }
                weakself.commentContentData = mutableData;
                weakself.totalNumber = content[@"content"][@"re"][@"total"];
                [weakself.commentContentTable reloadData];
            } else {
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = @"商品评论获取失败";
                [weakself.toast show:^{}];
            }
        };
        [self.urlRequest startRequest:temp pathUrl:@"/getCommentByGoodsId"];
    }
}

- (void) sectionHeaderConstrains {
    [self.commentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionHeaderView.mas_top).mas_offset(10);
        make.left.equalTo(self.sectionHeaderView.mas_left).mas_offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    [self.commentScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTitle.mas_bottom).mas_offset(30);
        make.left.equalTo(self.sectionHeaderView.mas_left).mas_offset(15);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    [self.commentResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTitle.mas_bottom).mas_offset(20);
        make.left.equalTo(self.commentScore.mas_right).mas_offset(20);
        make.right.equalTo(self.sectionHeaderView.mas_right).mas_offset(-10);
        make.height.equalTo(@90);
    }];
    [self.totalPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentResult.mas_bottom).mas_offset(10);
        make.left.equalTo(self.sectionHeaderView.mas_left).mas_offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    [self.commentNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentResult.mas_bottom).mas_offset(20);
        make.right.equalTo(self.sectionHeaderView.mas_right).mas_offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalPoint.mas_bottom).mas_offset(25);
        make.left.equalTo(self.sectionHeaderView.mas_left).mas_offset(20);
        make.right.equalTo(self.sectionHeaderView.mas_right).mas_offset(-20);
        make.height.equalTo(@1);
    }];
    [self.commentTheme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sectionHeaderView.mas_left);
        make.right.equalTo(self.sectionHeaderView.mas_right);
        make.top.equalTo(self.separator.mas_bottom);
        make.height.equalTo(@40);
    }];
    [self.separatorComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTheme.mas_bottom);
        make.left.equalTo(self.sectionHeaderView.mas_left).mas_offset(20);
        make.right.equalTo(self.sectionHeaderView.mas_right).mas_offset(-20);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.sectionHeaderView.mas_bottom).mas_offset(-1);
    }];
}

- (void) drawLine {
    int sum = 0;
    NSLog(@"%@", self.starArray);
    NSArray *arr = [NSArray array];
    if (self.starArray != NULL) {
        sum = [self.starArray[@"oneStar"] intValue] + [self.starArray[@"twoStar"] intValue] + [self.starArray[@"threeStar"] intValue] + [self.starArray[@"fourStar"] intValue] + [self.starArray[@"fiveStar"] intValue];
        arr = @[self.starArray[@"oneStar"], self.starArray[@"twoStar"], self.starArray[@"threeStar"], self.starArray[@"fourStar"], self.starArray[@"fiveStar"]];
    }
    //评论类别
    for (int i = 0; i < 5; i++) {
        //画星
        int starRadius = 5;//外接圆半径
        int defaultNumber = 5 - i;//默认画五个星
        CGFloat height = starRadius+starRadius*cos(M_PI/10);
        CGFloat width = 2*defaultNumber*starRadius*cos(M_PI/10);
        StarView *commentLevel = [[StarView alloc]initWithFrame:CGRectMake(10 + 10*i*cos(M_PI/10),5 + i * height + i*8, width, height)];
        commentLevel.defaultNumber = defaultNumber;//画几个星
        commentLevel.starWithColorNumber = 5 - i;//有几个带颜色的星
        commentLevel.starColor = [UIColor colorWithHexString:@"#666666"];
        commentLevel.starRadius = 5;
        [self.commentResult addSubview:commentLevel];
        //必须得写，这才是画星
        [commentLevel updateLayout];
        //画线
        UIView *totalComment = [[UIView alloc]initWithFrame:CGRectMake(40 + 50 * cos(M_PI/10), 5 + i * height + i*8, 200, height)];
        totalComment.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self.commentResult addSubview:totalComment];
        if (sum == 0) {
            UIView *everLevelComment = [[UIView alloc]initWithFrame:CGRectMake(40 + 50 * cos(M_PI/10), 5 + i * height + i*8, 0, height)];
            everLevelComment.backgroundColor = [UIColor colorWithHexString:@"#666666"];
            [self.commentResult addSubview:everLevelComment];
        } else {
            UIView *everLevelComment = [[UIView alloc]initWithFrame:CGRectMake(40 + 50 * cos(M_PI/10), 5 + i * height + i*8, 200*[arr[4 - i] intValue]/sum, height)];
            everLevelComment.backgroundColor = [UIColor colorWithHexString:@"#666666"];
            [self.commentResult addSubview:everLevelComment];
        }
    }
}

#pragma mark - Getters and Setters

@end
