//
//  StarView.m
//  ucareshop
//
//  Created by liushuting on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "StarView.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface StarView ()

#pragma mark - 私有属性

@end

@implementation StarView


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

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.backgroundColor = UIColor.clearColor;
    CGFloat innerRadius = self.starRadius*sin(M_PI/10)/cos(M_PI/5);
    for (int i = 0; i < self.defaultNumber; i++) {
        UIView *starView = [[UIView alloc]initWithFrame:CGRectMake(2*self.starRadius*cos(M_PI/10)*i, 0, 2*self.starRadius*cos(M_PI/10), self.starRadius+self.starRadius*cos(M_PI/10))];
        CAShapeLayer *starMask = [CAShapeLayer layer];
        CGPoint firstPoint = CGPointMake(self.starRadius, 0);
        CGPoint secondPoint = CGPointMake(self.starRadius+innerRadius*sin(M_PI/5), self.starRadius - innerRadius*cos(M_PI/5));
        CGPoint thirdPoint = CGPointMake(self.starRadius*cos(M_PI/10)+self.starRadius, self.starRadius-self.starRadius*sin(M_PI/10));
        CGPoint forthPoint = CGPointMake(self.starRadius + innerRadius*sin(3*M_PI/10), self.starRadius + innerRadius*cos(3*M_PI/10));
        CGPoint fifthPoint = CGPointMake(self.starRadius*cos(M_PI*3/10)+self.starRadius, self.starRadius+self.starRadius*sin(M_PI*3/10));
        CGPoint sixthPoint = CGPointMake(self.starRadius, self.starRadius+innerRadius);
        CGPoint seventhPoint = CGPointMake(self.starRadius-self.starRadius*cos(M_PI*3/10), self.starRadius+self.starRadius*sin(M_PI*3/10));
        CGPoint eighthPoint = CGPointMake(self.starRadius - innerRadius*sin(3*M_PI/10), self.starRadius + innerRadius*cos(3*M_PI/10));
        CGPoint ninethPoint = CGPointMake(self.starRadius-self.starRadius*cos(M_PI/10), self.starRadius-self.starRadius*sin(M_PI/10));
        CGPoint tenthPoint = CGPointMake(self.starRadius - innerRadius*sin(M_PI/5), self.starRadius - innerRadius*cos(M_PI/5));
        UIBezierPath *starMaskPath = [UIBezierPath bezierPath];
        [starMaskPath moveToPoint:firstPoint];
        [starMaskPath addLineToPoint:secondPoint];
        [starMaskPath addLineToPoint:thirdPoint];
        [starMaskPath addLineToPoint:forthPoint];
        [starMaskPath addLineToPoint:fifthPoint];
        [starMaskPath addLineToPoint:sixthPoint];
        [starMaskPath addLineToPoint:seventhPoint];
        [starMaskPath addLineToPoint:eighthPoint];
        [starMaskPath addLineToPoint:ninethPoint];
        [starMaskPath addLineToPoint:tenthPoint];
        [starMaskPath closePath];
        starMask.path = starMaskPath.CGPath;
        starMask.strokeColor = _starColor.CGColor;
        if (i < self.starWithColorNumber) {
            starMask.fillColor = _starColor.CGColor;
        } else {
            starMask.fillColor = UIColor.whiteColor.CGColor;
        }
        [starView.layer addSublayer:starMask];
        [self addSubview:starView];
    }
}

- (void) updateLayout {
    if (self.defaultNumber == 0) {
        self.defaultNumber = 5;
    }
    if (self.starWithColorNumber == 0) {
        self.starWithColorNumber = 0;
    }
    if (!self.starColor) {
        self.starColor = UIColor.redColor;
    }
    [self createSubViews];
}
#pragma mark - Getters and Setters

@end
