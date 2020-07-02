//
//  CommentBottomContentCell.m
//  ucareshop
//
//  Created by liushuting on 2019/9/6.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CommentBottomContentCell.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface CommentBottomContentCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *commentTopic;
@property (nonatomic, strong, readwrite) StarView *star;
@property (nonatomic, strong, readwrite) UILabel *userName;
@property (nonatomic, strong, readwrite) UILabel *commentData;
@property (nonatomic, assign, readwrite) CGFloat starViewHeight;
@property (nonatomic, assign, readwrite) CGFloat starViewWidth;
@property (nonatomic, strong, readwrite) UILabel *commentContent;

@end

@implementation CommentBottomContentCell

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

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.commentTopic = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentTopic.font = [UIFont systemFontOfSize:14];
    self.commentTopic.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.commentTopic];
    
    self.commentData = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentData.textColor = [UIColor colorWithHexString:@"#b9b9b9"];
    self.commentData.font = [UIFont systemFontOfSize:14];
    self.commentData.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.commentData];
    
    int starRadius = 5;//外接圆半径
    int defaultNumber = 5;//默认画五个星
    self.star = [[StarView alloc]initWithFrame:CGRectMake(100, 100, 2*defaultNumber*starRadius*cos(M_PI/10), starRadius+starRadius*cos(M_PI/10))];
    self.starViewHeight = starRadius+starRadius*cos(M_PI/10);
    self.starViewWidth = 2*defaultNumber*starRadius*cos(M_PI/10);
    self.star.starColor = [UIColor colorWithHexString:@"#fd622b"];
    self.star.starWithColorNumber = 5;
    _star.starRadius = starRadius;
    _star.defaultNumber = defaultNumber;
    [_star updateLayout];
    [self.contentView addSubview:_star];
    
    self.userName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userName.textColor = [UIColor colorWithHexString:@"#b9b9b9"];
    self.userName.textAlignment = NSTextAlignmentRight;
    self.userName.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.userName];
    self.commentContent = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentContent.textAlignment = NSTextAlignmentLeft;
    self.commentContent.numberOfLines = 0;
    self.commentContent.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.commentContent];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.commentTopic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(2);
        make.left.equalTo(self.contentView.mas_left).mas_offset(10);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-50);
        make.height.equalTo(@30);
    }];
    [self.commentData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTopic.mas_bottom).mas_offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
    }];
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTopic.mas_bottom).mas_offset(10);
        make.left.equalTo(self.contentView.mas_left).mas_offset(10);
        make.width.equalTo(@(self.starViewWidth));
        make.height.equalTo(@(self.starViewHeight));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentData.mas_bottom).mas_offset(5);
        make.left.equalTo(self.star.mas_right).mas_offset(10);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-10);
        make.height.equalTo(@30);
    }];
    [self.commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.star.mas_bottom).mas_offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-7);
        make.left.equalTo(self.contentView.mas_left).mas_offset(10);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
}
#pragma mark - Getters and Setters

@end
