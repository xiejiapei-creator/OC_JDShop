//
//  CollectionTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CollectionTableViewCell.h"
#import "EventCollectionViewCell.h"
#import "UCARInnerLoadingView.h"
#import "CommodityDetailViewController.h"
#import "UICollectionWaterLayout.h"
#import "RefreshView.h"
#import <UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

//集合视图列数，即：每一行有几个单元格
#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT self.contentView.frame.size.height
const NSInteger columnNumber = 3;
NSString * const cellReuseIdentifier = @"cell";

#pragma mark - 枚举

typedef NS_ENUM(NSUInteger, RefreshState) {
    RefreshStateNormal,//正常
    RefreshStatePulling,//释放即可刷新
    RefreshStateLoading,//加载中
};


@interface CollectionTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

#pragma mark - 私有属性


@property(nonatomic) NSMutableArray *dataA;

//下拉刷新
@property(nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UCARInnerLoadingView *refreshView;
@property (nonatomic, assign, readwrite) RefreshState refreshState;
@property (nonatomic, assign, readwrite) NSInteger dataStatus;

@end

@implementation CollectionTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        [self createSubViewsConstraints];
        [self urlRequestForCollection];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    int num = self.events.count % columnNumber;
//    if (num == 0) {//偶数
//        return self.events.count / columnNumber;
//    } else {//奇数
//        return self.events.count / columnNumber + 1;
//    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.events.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
//    //计算events集合下标索引
//    NSInteger index = indexPath.section * columnNumber + indexPath.row;
//    if (self.events.count <= index) { //防止下标越界
//        return cell;
//    }
    
    NSDictionary *event = self.events[indexPath.item];
    NSDictionary *goodsDTO = event[@"goodsDTO"];
    cell.nameLabel.text = goodsDTO[@"goodsName"];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",goodsDTO[@"salePrice"]];

    //异步加载显示图片
    NSArray *picUrlList = event[@"picUrlList"];
    [cell.imageView sd_setImageWithURL:picUrlList[0]];
    
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
    
//    cell.layer.borderWidth = 0;
//    cell.layer.borderColor = [UIColor grayColor].CGColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //计算events集合下标索引
//    NSInteger index = indexPath.section * columnNumber + indexPath.row;
    NSDictionary *event = self.events[indexPath.item];
    NSDictionary *goodsDTO = event[@"goodsDTO"];
    NSInteger goodID = [goodsDTO[@"goodsId"] integerValue];
    self.goodsId = [NSString stringWithFormat:@"%ld",(long)goodID];
    self.blockProperty(indexPath.item, self.goodsId);
    if ([self.delegate respondsToSelector:@selector(itemDidSelected:)]) {
        [self.delegate itemDidSelected:indexPath.item];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if(scrollView.contentOffset.y < -64){
//        if(self.refreshState == RefreshStateNormal){//小于临界值（在触发点以下），如果状态是正常就转为下拉刷新，如果正在刷新或者已经是下拉刷新则不变
//            self.refreshState = RefreshStatePulling;
//        }
//    }else{//大于临界值（在触发点以上，包括触发点）
//        if(scrollView.isDragging){//手指没有离开屏幕
//            if(self.refreshState == RefreshStatePulling){//原来是下拉的话变成正常，原来是刷新或者正常的话不变
//                self.refreshState = RefreshStateNormal;
//            }
//        }else{//手指离开屏幕
//            if(self.refreshState == RefreshStatePulling){//原来是下拉的话变成加载中，原来是加载中或者正常的话不变
//                [self startRefresh];
//            }
//        }
//    }

    NSLog(@"w-----%f",scrollView.contentOffset.y);
    if (_canContentScroll == false)
    {
       // 这里通过固定contentOffset，来实现不滚动
//       scrollView.contentOffset = CGPointZero;
       scrollView.scrollEnabled = NO;
    }
    else
    {
        scrollView.scrollEnabled = YES;
        if (scrollView.contentOffset.y <= 0)
        {
              scrollView.scrollEnabled=NO;
//            if (!self.fingerIsTouch)
//            {
//                return;
//            }
            // 通知容器可以开始滚动
//            _canContentScroll = NO;
//            scrollView.contentOffset = CGPointZero;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
        }
    }
    scrollView.showsVerticalScrollIndicator = _canContentScroll?YES:NO;
}
#pragma mark - Custom Delegates

//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.fingerIsTouch = NO;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    //设置集合视图布局
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(90, 130);
//    layout.sectionInset = UIEdgeInsetsMake(15, 15, 20, 20);//内边距
//    layout.minimumLineSpacing = 5;//单元格之间的间距
    
    //不规则瀑布流
    if (self.dataA) {
    UICollectionWaterLayout *layout = [UICollectionWaterLayout layoutWithColoumn:3 data:self.dataA verticleMin:10 horizonMin:10 leftMargin:10 rightMargin:10];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBounces:NO];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = YES;
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[EventCollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    }
    
/* 系统
    self.refreshControl = [[UIRefreshControl alloc] init];
    //注意这里，collectionView 的 alwaysBounceVertical 必须打开
    //高度没有超过屏幕时不会开启滑动，当然也就无法触发下拉刷新
    self.collectionView.alwaysBounceVertical = YES;
    self.refreshControl.tintColor = [UIColor grayColor];
    //下拉刷新
    [self.refreshControl addTarget:self action:@selector(urlRequestForCollection) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
 */
    //自定义
    self.refreshView = [[UCARInnerLoadingView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2+20, -44, 40, 40)];
//    [self.collectionView addSubview:self.refreshView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (void)urlRequestForCollection {
    self.urlRequest = [[URLRequest alloc] init];
    //集合视图的数据
    __weak CollectionTableViewCell *weakSelf = self;
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
         if (errorStatusCode == 1) {
             NSDictionary *dict = content[@"content"];
             weakSelf.events = [NSMutableArray arrayWithArray:dict[@"re"]];
             //不规则瀑布布局
             [weakSelf.dataA removeAllObjects];
             for (int i = 0; i < self.events.count; i++) {
                 int iconH = [weakSelf getRandomNumber:40 to:70];
                 int iconW = [weakSelf getRandomNumber:30 to:60];
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                 [dict setObject:@(iconH) forKey:@"iconH"];
                 [dict setObject:@(iconW) forKey:@"iconW"];
                 IconModel *iconModel = [IconModel IconWithDictionay:dict];
                 [weakSelf.dataA addObject:iconModel];
             }
             [weakSelf.collectionView reloadData];
             [weakSelf endRefresh];
             //[weakSelf.refreshControl endRefreshing];
         } else {
             NSLog(@"%@",content[@"msg"]);
         }
    };
    [self.urlRequest startRequest:nil pathUrl:@"/getPopularGoods"];
    
}
//随机数
-(int)getRandomNumber:(int)from to:(int)to
{
    int x = arc4random() % (to - from + 1) + from;
    return x;
}

#pragma mark - 下拉刷新
// 下拉刷新
- (void)setupRefresh {
    __weak CollectionTableViewCell *weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [weakself urlRequestForCollection];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [weakself.collectionView reloadData];
            
        });
    });
}
// 开始刷新
- (void) startRefresh {
    //改变contentInset的值就可以取消回弹效果停留在当前位置了
    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.refreshState = RefreshStateLoading;
}
// 结束刷新
- (void)endRefresh {
    if(self.refreshState == RefreshStateLoading){
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            self.refreshState = RefreshStateNormal;
            [self.refreshView stopAnimation];
        }];
    }
}
//设置刷新状态
- (void)setRefreshState:(RefreshState)refreshState{
    __weak CollectionTableViewCell *weakself = self;
    _refreshState = refreshState;
    switch (refreshState) {
        case RefreshStateNormal:
            break;
        case RefreshStateLoading: {
            [self setupRefresh];
            if (weakself.dataStatus == 0) {
                [weakself.refreshView startAnimation];
            } else {
                [weakself endRefresh];
            }
            break;
        }
        case RefreshStatePulling:
            [weakself.refreshView startAnimation];
            break;
        default:
            break;
    }
}

#pragma mark - Getters and Setters
- (NSMutableArray *)dataA{
    if(_dataA == nil){
        _dataA = [NSMutableArray array];
    }
    return _dataA;
}

- (void)setCanContentScroll:(BOOL)canContentScroll
{
    _canContentScroll = canContentScroll;
    if (!canContentScroll)
    {
        //如果cell不能滑动，代表到了顶部，修改所有子vc的状态回到顶部
        self.collectionView.contentOffset = CGPointZero;
    }
    else
    {
        self.collectionView.scrollEnabled = YES;
    }
}

@end
