//
//  SearchResultView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/30.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "SearchResultView.h"
#import "SearchResultCell.h"
#import "URLRequest.h"
#import <UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量
//集合视图列数，即：每一行有几个单元格
const NSInteger columnNum = 3;

//集合视图列数，即：每一行有几个单元格
const NSInteger searchColumnNumber = 3;
NSString * const searchCellReuseIdentifier = @"cell";


#pragma mark - 枚举

@interface SearchResultView () <UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate,UITextFieldDelegate>

#pragma mark - 私有属性


@end

@implementation SearchResultView


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

#pragma mark - UIOtherComponentDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.events.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView registerClass:[SearchResultCell class] forCellWithReuseIdentifier:searchCellReuseIdentifier];
    SearchResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:searchCellReuseIdentifier forIndexPath:indexPath];

    cell.layer.cornerRadius = 8.0f;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2].CGColor;
    cell.layer.masksToBounds = YES;

    
    cell.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:250/255. alpha:1].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    NSDictionary *event = self.events[indexPath.item];
    NSDictionary *goodsDTO = event[@"goodsDTO"];
    cell.nameLabel.text = goodsDTO[@"goodsName"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",goodsDTO[@"salePrice"]];
    //异步加载显示图片
    NSArray *picUrlList = event[@"picUrlList"];
    [cell.imageView sd_setImageWithURL:picUrlList[0]];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //计算events集合下标索引
    NSDictionary *event = self.events[indexPath.item];
    NSDictionary *goodsDTO = event[@"goodsDTO"];
    self.goodsId = goodsDTO[@"goodsId"];
    self.blockGoodsId(self.goodsId);
}

#pragma mark - Custom Delegates
// 允许选中时，高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{return YES;}
// 高亮完成后回调
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{}
// 由高亮转成非高亮完成时的回调
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{}
// 设置是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{return YES;}
// 设置是否允许取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{return YES;}
// 取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{}

//#pragma mark --实现UISearchBarDelegate协议方法

- (NSString *)text {
    _text = self.searchTextField.text;
    return _text;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    //设置集合视图布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(90, 130);
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 20, 20);//内边距
    layout.minimumLineSpacing = 5;//上下行间距
    layout.minimumInteritemSpacing = 5;//左右行间距
    //layout.headerReferenceSize = CGSizeMake(self.frame.size.width, 40);//头视图的参考大小
    //layout.footerReferenceSize = CGSizeMake(self.frame.size.width, 40);//尾视图的参考大小
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = YES;
    [self addSubview:self.collectionView];
    
    //搜索栏
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchTextField.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_search"]];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_clear_normal"] forState:UIControlStateNormal];
    [self.clearButton setImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_clear_selected"] forState:UIControlStateHighlighted];
    self.clearButton.frame = CGRectMake(0, 0, 30, 30);
    self.searchTextField.rightView = self.clearButton;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.searchTextField setEnabled:YES];
    [self addSubview:self.searchTextField];
}

- (void)reload {
    [self.collectionView reloadData];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@380);
        make.height.equalTo(@44);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTextField).offset(60);
        make.left.right.bottom.equalTo(self);
    }];
}

#pragma mark - Getters and Setters

@end
