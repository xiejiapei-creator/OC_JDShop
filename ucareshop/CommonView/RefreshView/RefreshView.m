//
//  RefreshView.m
//  ucareshop
//
//  Created by liushuting on 2019/9/25.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "RefreshView.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

const CGFloat UCARPullLoadingViewSize = 30.0;

@interface RefreshView ()

@property (nonatomic, strong) CALayer *wheelLayer;
@property (nonatomic, strong) NSArray *windLayers;
@property (nonatomic, strong) NSArray *windOffsets;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation RefreshView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRefresh];
    }
    return self;
}

- (CGPoint)resetWindLayerPositionWithIndex:(NSInteger)index {
    CGFloat positionX = self.bounds.size.width/2 + 23/2 - 3;
    CGFloat positionYDelta = 5;
    CGFloat positionYStart = self.bounds.size.width/2 - positionYDelta;
    return CGPointMake(positionX, positionYStart + positionYDelta*index);
}

- (CGPoint)calcPointWithAngle:(CGFloat)angle radius:(CGFloat)radius center:(CGPoint)center {
    CGFloat postionX = center.x + radius * cos(angle);
    CGFloat postionY = center.y + radius * sin(angle);
    return CGPointMake(postionX, postionY);
}

- (void)displayDidRefresh:(id)sender {
    if (_scrollView) {
        CGFloat distance = _scrollView.contentOffset.y;
        CGFloat angle = - (M_PI * 2 * distance / _distanceForTurnOneCycle);
        CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
        [_wheelLayer setAffineTransform:transform];
    }
}

- (void)loading {
    _displayLink.paused = YES;
    [self wheelAnimation];
    [self windAnimation];
}

- (void)wheelAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(M_PI*2);
    animation.toValue = @(0);
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.duration = 1.0;
    [_wheelLayer addAnimation:animation forKey:@"loading"];
}

- (void)windAnimation {
    for (int i=0; i<3; i++) {
        [self addAnimationToWindLayerForIndex:i];
    }

}

- (void)addAnimationToWindLayerForIndex:(NSInteger)index {
    CGFloat duration = 1.5;
    
    CGPoint startPosition = [self resetWindLayerPositionWithIndex:index];
    CGFloat offsetX = [_windOffsets[index] floatValue];
    CGPoint endPosition = CGPointMake(startPosition.x+offsetX, startPosition.y);
    NSArray *positions = @[[NSValue valueWithCGPoint:startPosition],
                           [NSValue valueWithCGPoint:endPosition],
                           [NSValue valueWithCGPoint:endPosition],
                           [NSValue valueWithCGPoint:startPosition]];
    NSArray *positionKeyTimes = @[@0, @(1.0/duration), @(1.3/duration), @1.0];
    NSArray *positionFunctions = @[[CAMediaTimingFunction functionWithName:
                                   kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:
                                   kCAMediaTimingFunctionLinear],
                                  [CAMediaTimingFunction functionWithName:
                                   kCAMediaTimingFunctionLinear]];
    
    NSArray *opacities = @[@0.0, @1.0, @1.0, @0.0, @0.0];
    NSArray *opacityKeyTimes = @[@0, @(0.3/duration), @(1.0/duration), @(1.3/duration), @1.0];
    NSArray *opacityFunctions = @[[CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionLinear],
                               [CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:
                                kCAMediaTimingFunctionLinear]];
    
    
    CALayer *windLayer = _windLayers[index];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = opacities;
    opacityAnimation.keyTimes = opacityKeyTimes;
    opacityAnimation.timingFunctions = opacityFunctions;
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = positions;
    positionAnimation.keyTimes = positionKeyTimes;
    positionAnimation.timingFunctions = positionFunctions;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[opacityAnimation, positionAnimation];
    groupAnimation.duration = duration;
    groupAnimation.repeatCount = HUGE_VALF;
    
    [windLayer addAnimation:groupAnimation forKey:@"wind"];
}

- (void)loadingFinished {
    _displayLink.paused = NO;
    [_wheelLayer removeAnimationForKey:@"loading"];
    for (CALayer *layer in _windLayers) {
        [layer removeAllAnimations];
    }
}

- (void)dealloc
{
    [_displayLink invalidate];
}

- (void) drawRefresh {
    _distanceForTurnOneCycle = 80;
    
    FLWeakProxy *weakProxy = [FLWeakProxy weakProxyForObject:self];
    _displayLink = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(displayDidRefresh:)];
    
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
    CGFloat halfWidth = self.bounds.size.width / 2;
    //位置半径
    CGPoint center = CGPointMake(halfWidth, halfWidth);
    
    _wheelLayer = [CALayer layer];
    _wheelLayer.frame = self.bounds;
    [self.layer addSublayer:_wheelLayer];
    
    //拆分为两部分，轮胎使用描边，扇叶使用填充
    //轮胎
    UIBezierPath *wheelMaskPath = [UIBezierPath bezierPathWithArcCenter:center radius:halfWidth startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *wheelMask = [CAShapeLayer layer];
    wheelMask.frame = self.bounds;
    wheelMask.path = wheelMaskPath.CGPath;
    
    CGFloat tyreRadius = 23/2 - 1.5;
    UIColor *tyreColor = [UIColor redColor];
    CAShapeLayer *tyreLayer = [CAShapeLayer layer];
    UIBezierPath *tyrePath =[UIBezierPath bezierPathWithArcCenter:center radius:tyreRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [tyrePath closePath];
    tyreLayer.path = tyrePath.CGPath;
    tyreLayer.strokeColor = tyreColor.CGColor;
    tyreLayer.lineWidth = 3;
    tyreLayer.fillColor = [UIColor clearColor].CGColor;
    tyreLayer.frame = self.bounds;
    tyreLayer.mask = wheelMask;
    [_wheelLayer addSublayer:tyreLayer];
    
    //扇叶
    CGFloat innerRadius = 7/2;
    CGFloat outerRadius = 15/2;
    CGFloat angleDelta = M_PI * 2 / 5;
    CGFloat arcAngle = angleDelta * 2 / 3;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    for (int i=0; i<5; i++) {
        CGFloat startAngle = angleDelta * i;
        CGFloat endAngle = startAngle + arcAngle;
        CGPoint innerArcStart = [self calcPointWithAngle:endAngle radius:innerRadius center:center];
        CGPoint outerArcStart = [self calcPointWithAngle:startAngle radius:outerRadius center:center];
        //绘制路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        //外部弧
        [path addArcWithCenter:center radius:outerRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [path addLineToPoint:innerArcStart];
        [path addArcWithCenter:center radius:innerRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
        [path addLineToPoint:outerArcStart];
        [path closePath];
        [maskPath appendPath:path];
    }
    
    //内部环
    CGFloat dotRadius = 3.0 / 2;
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:center radius:dotRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [dotPath closePath];
    [maskPath appendPath:dotPath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    UIColor *fanBladeColor = [UIColor redColor];
    CALayer *fanBladeLayer = [CALayer layer];
    fanBladeLayer.backgroundColor = fanBladeColor.CGColor;
    fanBladeLayer.frame = self.bounds;
    fanBladeLayer.mask = maskLayer;
    //也可将fanBladeLayer添加到tyreLayer中
    [tyreLayer addSublayer:fanBladeLayer];
    
    UIColor *windColor = [UIColor redColor];
    NSMutableArray *windLayers = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(6, 0)];
        layer.path = path.CGPath;
        layer.strokeColor = windColor.CGColor;
        layer.lineWidth = 1.0;
        layer.position = [self resetWindLayerPositionWithIndex:i];
        layer.opacity = 0.0;
        [self.layer addSublayer:layer];
        [windLayers addObject:layer];
    }
    _windLayers = windLayers;
    _windOffsets = @[@18, @23, @16];
}
@end
