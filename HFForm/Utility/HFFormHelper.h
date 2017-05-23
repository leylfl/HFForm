//
//  HFFormHelper.h
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"

#define iOS8 ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0 ? YES : NO)

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define APP_WIDTH [[UIScreen mainScreen] applicationFrame].size.width

#define APP_Height [[UIScreen mainScreen] applicationFrame].size.height

#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf

@interface HFFormHelper : NSObject

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

+ (void)showNotice:(NSString *)notice;

@end
