//
//  NSString+HFForm.h
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HFForm)

- (NSArray *)getMatchesForRegex:(NSString *)regex;

@end
