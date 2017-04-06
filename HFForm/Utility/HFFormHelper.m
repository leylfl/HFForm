//
//  HFFormHelper.m
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormHelper.h"

@implementation HFFormHelper

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
