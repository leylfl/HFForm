//
//  NSBundle+HFForm.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/17.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "NSBundle+HFForm.h"

@implementation NSBundle (HFForm)

+ (instancetype)formBundle {
    static NSBundle *formBundle = nil;
    if (!formBundle) {
        formBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FormIcon" ofType:@"bundle"]];
    }
    return formBundle;
}

+ (UIImage *)albumPlaceholderImage {
    NSString *pngName = [NSString stringWithFormat:@"form_album_placeholder@%ldx",(long)[UIScreen mainScreen].scale];
    return [UIImage imageWithContentsOfFile:[[self formBundle] pathForResource:pngName ofType:@"png"]];
}

+ (UIImage *)questionTipImage {
    NSString *pngName = [NSString stringWithFormat:@"form_question_blue@%ldx",(long)[UIScreen mainScreen].scale];
    return [UIImage imageWithContentsOfFile:[[self formBundle] pathForResource:pngName ofType:@"png"]];
}

@end
