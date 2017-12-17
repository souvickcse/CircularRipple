//
//  RippleEffect.m
//  Tap
//
//  Created by Souvick Ghosh on 17/12/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "RippleEffect.h"

@implementation RippleEffect
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self drawCircle];
    });
}

- (void)drawCircle {
    UIColor *topColor       = [self getUIColorObjectFromHexString:self.StartColorHexCode alpha:1.0];
    UIColor *bottomColor    = [self getUIColorObjectFromHexString:self.EndColorHexCode alpha:1.0];
    float animationStartDelay = 0.5;
    for(int i=0;i<self.NoOfCircle;i++) {
        float initialRadius = self.frame.size.width>self.frame.size.height?((self.frame.size.height/2.0)-self.InitialRadiusPadding):((self.frame.size.width/2.0)-self.InitialRadiusPadding);
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:initialRadius+(i*self.CircleRadiusDifference) startAngle:0 endAngle:2 * M_PI clockwise:YES];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
        
        CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
        progressLayer.frame = self.bounds;
        [progressLayer setPath:bezierPath.CGPath];
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [UIColor blackColor].CGColor;
        [progressLayer setLineWidth:self.LineWidth];
        //progressLayer.opacity = 0.0;
        gradientLayer.mask = progressLayer;
        [self.layer addSublayer:gradientLayer];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationStartDelay+(i*0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self animateCircleLayer:progressLayer];
        });
    }
}

- (void)animateCircleLayer:(CAShapeLayer *)layer {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation,alphaAnimation];
    animation.duration = 2.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.repeatCount = HUGE_VALF;
    [layer addAnimation:animation forKey:nil];
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(float)alpha {
    
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexInt];
    
    UIColor *color = [UIColor colorWithRed:((CGFloat) ((hexInt & 0xFF0000) >> 16))/255
                                     green:((CGFloat) ((hexInt & 0xFF00) >> 8))/255
                                      blue:((CGFloat) (hexInt & 0xFF))/255
                                     alpha:alpha];
    return color;
}
@end



