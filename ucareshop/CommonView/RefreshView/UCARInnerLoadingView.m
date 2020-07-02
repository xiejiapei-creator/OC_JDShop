//
//  UCARInnerLoadingView.m
//  UCARUIKit
//
//  Created by 谢佳培 on 2019/9/4.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "UCARInnerLoadingView.h"

const CGFloat UCARInnerLoadingSize = 65.0;

@interface UCARInnerLoadingView ()

@property (nonatomic, strong) CALayer *loadingLayer;

@end

@implementation UCARInnerLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize size = self.bounds.size;
        CGFloat radius = size.width/2;
        //位置半径
        CGFloat dotRadius = 7.5 * (size.width/UCARInnerLoadingSize);
        CGFloat postionRadius = radius - dotRadius;
        CGFloat angleDelta = M_PI / 4;
        
        _loadingLayer = [CALayer layer];
        _loadingLayer.frame = self.bounds;
        [self.layer addSublayer:_loadingLayer];
        
        UIColor *ballColor = [UIColor blueColor];
        //绘制8个球
        for (int i=7; i>=0; i--) {
            //求取圆心
            CGFloat postionX = radius + postionRadius * cos(angleDelta*i);
            CGFloat postionY = radius + postionRadius * sin(angleDelta*i);
            //绘制路径
            UIBezierPath *dotPath = [UIBezierPath bezierPath];
            [dotPath addArcWithCenter:CGPointZero radius:dotRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
            [dotPath closePath];
            
            CAShapeLayer *dotLayer = [CAShapeLayer layer];
            dotLayer.position = CGPointMake(postionX, postionY);
            dotLayer.anchorPoint = CGPointZero;
            dotLayer.path = dotPath.CGPath;
            dotLayer.fillColor = ballColor.CGColor;
            [_loadingLayer addSublayer:dotLayer];
        }
    }
    return self;
}

- (void)startAnimation
{
    NSArray<CALayer *> *sublayers = _loadingLayer.sublayers;
    NSUInteger count = sublayers.count;
    CGFloat delayDelta = 0.12;
    for (int i=0; i<count; i++) {
        CALayer *subLayer = sublayers[i];
        
        NSArray *scales = @[@1.0, @0.4, @1.0];
        NSArray *opacities = @[@1.0, @0.3, @1.0];
        
        NSArray *keyTimes = @[@0, @0.5, @1.0];
        
        CGFloat duration = 2.0;
        
        //xScale
        CAKeyframeAnimation *xScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        xScaleAnimation.values = scales;
        xScaleAnimation.keyTimes = keyTimes;
        xScaleAnimation.duration = duration;
        
        CAKeyframeAnimation *yScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        yScaleAnimation.values = scales;
        yScaleAnimation.keyTimes = keyTimes;
        yScaleAnimation.duration = duration;
        
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = opacities;
        opacityAnimation.keyTimes = keyTimes;
        opacityAnimation.duration = duration;
        
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = @[xScaleAnimation, yScaleAnimation, opacityAnimation];
        groupAnimation.duration = duration;
        groupAnimation.removedOnCompletion = NO;
        groupAnimation.repeatCount = HUGE_VALF;
        groupAnimation.beginTime = delayDelta * i;
        
        [subLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
    }
    
}

- (void)stopAnimation
{
    NSArray<CALayer *> *sublayers = _loadingLayer.sublayers;
    NSUInteger count = sublayers.count;
    for (int i=0; i<count; i++) {
        CALayer *subLayer = sublayers[i];
        [subLayer removeAllAnimations];
    }
}


@end
