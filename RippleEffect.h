//
//  RippleEffect.h
//  Tap
//
//  Created by Souvick Ghosh on 17/12/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RippleEffect : UIView
@property IBInspectable int NoOfCircle;
@property (copy, nonatomic) IBInspectable NSString *StartColorHexCode;
@property (copy, nonatomic) IBInspectable NSString *EndColorHexCode;
@property IBInspectable float CircleRadiusDifference;
@property IBInspectable float LineWidth;
@property IBInspectable float InitialRadiusPadding;
@end
