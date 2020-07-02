//
//  AutoScrollView.m
//  ucareshop
//
//  Created by liushuting on 2019/9/2.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AutoScrollView.h"
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AutoScrollView ()<UIScrollViewDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UIScrollView *autoScrollView;
@property (nonatomic, strong, readwrite) UIView *scrollBox;
@property (nonatomic, assign, readwrite) NSInteger index;//当前第几页
@property (nonatomic, strong, readwrite) UIPageControl *pageView;


@end

@implementation AutoScrollView


#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
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

- (void) setScrollSize:(CGSize)scrollSize {
    _scrollSize = scrollSize;
    [self preAction];
    [self createSubViews];
    [self createSubViewsConstraints];
}
//判断变量状态，初始化数据
- (void) preAction {
    [self scrollCenter];
    [self reloadIndex];
    if (self.scrollSize.width == 0 || self.scrollSize.height == 0) {
        self.scrollSize = CGSizeMake(300, 200);
    }
    self.index = 0;
}
//每次滑动完，再滑动回中心
- (void)scrollCenter
{
    [self.autoScrollView setContentOffset:CGPointMake(self.scrollBox.bounds.size.width, 0)];
    self.pageView.currentPage = self.index;
}
//设置定时器
- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    if (duration > 0.0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(changeNext) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:duration]];
    }
}
//定时滚动函数
- (void)changeNext {
    [self.autoScrollView setContentOffset:CGPointMake(2*CGRectGetWidth(self.autoScrollView.bounds), 0) animated:YES];
}
//set函数
- (void)setIndex:(NSInteger)index {
    _index = index;
    [self recreate];
}

//重新赋值
- (void) recreate {
    NSInteger totalCount = self.scrollImage.count;
    NSInteger   leftIndex = (self.index + totalCount - 1) % totalCount;
    NSInteger   rightIndex = (self.index +  1) % totalCount;
    NSArray <UIImageView *> *subviews = self.autoScrollView.subviews;
//    subviews[0].image = [UIImage imageNamed: self.scrollImage[leftIndex]];
//    subviews[1].image = [UIImage imageNamed:self.scrollImage[self.index]];
//    subviews[2].image = [UIImage imageNamed:self.scrollImage[rightIndex]];
    subviews[0].image = self.scrollImage[leftIndex];
    subviews[1].image = self.scrollImage[self.index];
    subviews[2].image = self.scrollImage[rightIndex];
    [self scrollCenter];
}
//计算页数
- (void)reloadIndex {
    if (self.scrollImage && self.scrollImage.count > 0)
    {
        CGFloat pointX = self.autoScrollView.contentOffset.x;
        //此处的value用于边缘判断，当imageview距离两边间距小于1时，触发偏移
        CGFloat value = 0.2f;
        if (pointX > CGRectGetWidth(self.autoScrollView.bounds)*2 - value) {
            self.index = (self.index + 1) % self.scrollImage.count;
        } else if (pointX < value) {
            self.index = (self.index + self.scrollImage.count - 1) % self.scrollImage.count;
        }
    }
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self reloadIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageView.currentPage = self.index;
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.duration]];
    
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.scrollBox = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollSize.width, self.scrollSize.height)];
    [self addSubview:self.scrollBox];
    self.autoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.scrollSize.width, self.scrollSize.height)];
    self.autoScrollView.pagingEnabled = YES;
    self.autoScrollView.scrollEnabled = YES;
    self.autoScrollView.showsHorizontalScrollIndicator = NO;
    self.autoScrollView.showsVerticalScrollIndicator = NO;
    self.autoScrollView.minimumZoomScale = 0.5;
    self.autoScrollView.maximumZoomScale = 2.0;
    self.autoScrollView.delegate = self;
    self.autoScrollView.backgroundColor = UIColor.whiteColor;
    self.autoScrollView.userInteractionEnabled = YES;
    [self.scrollBox addSubview:self.autoScrollView];
    
    CGSize viewSize = self.scrollBox.bounds.size;
    self.autoScrollView.contentSize = CGSizeMake(3*viewSize.width, viewSize.height);
    //添加子视图
    for (int i = 0; i < self.scrollImage.count;i++) {
        UIImageView *imageView = [self addViewToScrollView:i *viewSize.width];
        imageView.image = self.scrollImage[(i-1)%self.scrollImage.count];
        //填充模式
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self.autoScrollView setContentOffset:CGPointMake(viewSize.width, 0)];
    
    self.pageView = [[UIPageControl alloc]initWithFrame:CGRectZero];
    self.pageView.numberOfPages = self.scrollImage.count;
    self.pageView.currentPageIndicatorTintColor = [UIColor greenColor];
    self.pageView.userInteractionEnabled = NO;
    [self addSubview:self.pageView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.autoScrollView.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (UIImageView *)addViewToScrollView : (CGFloat)offsetX {
    CGSize viewSize = self.scrollBox.bounds.size;
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, 0, viewSize.width, viewSize.height)];
    [self.autoScrollView addSubview:view];
    return view;
}

#pragma mark - Getters and Setters

@end
