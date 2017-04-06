//
//  NSString+HFForm.m
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "NSString+HFForm.h"

@implementation NSString (HFForm)

- (NSArray *)getMatchesForRegex:(NSString *)regex{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    
    NSError * error;
    NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray * matches                = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (int i = 0; i < matches.count; i++) {
        NSTextCheckingResult * result = [matches objectAtIndex:i];
        
        for (int j = 0; j < result.numberOfRanges; j++) {
            NSRange range = [result rangeAtIndex:j];
            if (range.location == NSNotFound) {
                continue;
            }
            NSString * string = [self substringWithRange:range];
            [array addObject:string];
        }
    }
    
    return array;
}

@end
