//
//  PageControllTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "PageControllTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT self.contentView.frame.size.height

#pragma mark - 枚举

@interface PageControllTableViewCell () <UIScrollViewDelegate>

#pragma mark - 私有属性


@property(strong, nonatomic) UIImageView *page1;
@property(strong, nonatomic) UIImageView *page2;
@property(strong, nonatomic) UIImageView *page3;

@end

@implementation PageControllTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

//实现UIPageControl事件处理
- (void)changePage:(id)sender {
    [UIView animateWithDuration:1.0f animations:^{
        NSInteger whichPage = self.pageControl.currentPage;
        if (whichPage < 2) {
            self.scrollView.contentOffset = CGPointMake(WIDTH * whichPage, 0.0f);
            [self loadImage:self.pageControl.currentPage + 1];
        } else {
            self.pageControl.currentPage = 0;
            self.scrollView.contentOffset = CGPointMake(0, 0.0f);
        }
    }];
}


#pragma mark - UIOtherComponentDelegate

#pragma mark --实现UIScrollViewDelegate委托协议

- (void) scrollViewDidScroll: (UIScrollView *) scrollView {
        if (self.pageControl.currentPage < 2) {
            self.pageControl.currentPage = scrollView.contentOffset.x / WIDTH;
            [self loadImage:self.pageControl.currentPage + 1];
        } else {
            self.pageControl.currentPage = 0;
            self.scrollView.contentOffset = CGPointMake(0, 0.0f);
        }
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    //分页视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
    self.scrollView.delegate = self;
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 3;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents: UIControlEventValueChanged];
    
    self.page1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"达芬奇-蒙娜丽莎.png"]];
    [self.scrollView addSubview:self.page1];
    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.pageControl];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@25);
        make.width.equalTo(@200);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.page1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
//延迟加载
- (void)loadImage:(NSInteger)nextPage {
    if (nextPage == 1 && self.page2 == nil) {
        self.page2 = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH, 0.0f, WIDTH, HEIGHT)];
        self.page2.image = [UIImage imageNamed:@"罗丹-思想者.png"];
        [self.scrollView addSubview:self.page2];
    }
    
    if (nextPage == 2 && self.page3 == nil) {
        self.page3 = [[UIImageView alloc] initWithFrame:CGRectMake(2 * WIDTH, 0.0f, WIDTH, HEIGHT)];
        self.page3.image = [UIImage imageNamed:@"保罗克利-肖像.png"];
        [self.scrollView addSubview:self.page3];
    }
    
}
#pragma mark - Getters and Setters

@end
