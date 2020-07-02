//
//  CommodityDetailView.m
//  ucareshop
//
//  Created by liushuting on 2019/8/20.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CommodityDetailView.h"
#import "AutoScrollView.h"
#import "Masonry.h"
#import <ChameleonFramework/Chameleon.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface CommodityDetailView ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *detailContent;
@property (nonatomic, strong, readwrite) UIImageView *detailImage;
@property (nonatomic, strong, readwrite) UIView *sectionHeaderView;
@property (nonatomic, strong, readwrite) UITableView *detailTableView;
@property (nonatomic, assign, readwrite) CGFloat commentContentHeight;

@end

@implementation CommodityDetailView


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

#pragma mark - UIOtherComponentDelegate

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 400)];
    self.detailContent = [[UILabel alloc]initWithFrame:CGRectZero];
    self.detailContent.textAlignment = NSTextAlignmentCenter;
    self.detailContent.font = [UIFont systemFontOfSize:16];
    self.detailContent.numberOfLines = 0;
    [self.sectionHeaderView addSubview:self.detailContent];
    
    self.detailImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.detailImage.contentMode = UIViewContentModeScaleAspectFit;
    self.detailImage.layer.borderColor = UIColor.whiteColor.CGColor;
    self.detailImage.layer.borderWidth = 1.0;
    self.detailImage.layer.cornerRadius = 20.0;
    self.detailImage.layer.masksToBounds = YES;
    [self.sectionHeaderView addSubview:self.detailImage];
    [self sectionHeaderViewConstrains];
    self.commentContentHeight = [self calculateHeightOfText:self.detailContent].size.height + 100;
    return self.sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.detailTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.detailTableView];
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectZero];
    text.text = @"gweuigfuefeuwfgeufgweufgeufgeugfegfeufgewiuofgfupwgfwpuefgwgfpdjdyusdytdytjdtjdtjdtduk6ei6essrysfgzxfgxfgxghdxjfdyukfdkyudkyudtudydfyxfhxrsr";
    self.commentContentHeight = [self calculateHeightOfText:text].size.height;
    self.detailTableView.sectionHeaderHeight = self.commentContentHeight + 140;
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
    }];
}

- (void) updateContentConstrain {
    CGFloat height = [self calculateHeightOfText:self.detailContent].size.height;
    [self.detailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionHeaderView.mas_top).mas_offset(10);
        make.left.equalTo(self.sectionHeaderView.mas_left).mas_offset(10);
        make.right.equalTo(self.sectionHeaderView.mas_right).mas_offset(-10);
        make.height.equalTo(@(height));
    }];
}

- (void) sectionHeaderViewConstrains {
    [self.detailContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionHeaderView.mas_top).mas_offset(10);
        make.left.equalTo(self.sectionHeaderView.mas_left).mas_offset(10);
        make.right.equalTo(self.sectionHeaderView.mas_right).mas_offset(-10);
        make.height.equalTo(@50);
    }];
    [self.detailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sectionHeaderView.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
        make.top.equalTo(self.detailContent.mas_bottom).mas_offset(10);
        make.bottom.equalTo(self.sectionHeaderView.mas_bottom).mas_offset(-10);
    }];
}

#pragma mark - Getters and Setters

@end
