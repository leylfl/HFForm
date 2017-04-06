//
//  UIResponder+HFForm.m
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "UIResponder+HFForm.h"
#import <objc/runtime.h>

static char *HFFormFirstResponderKey = "HFFormFirstResponderKey";

@implementation UIResponder (HFForm)

- (id)currentFirstResponder {
    [UIApplication.sharedApplication sendAction:@selector(findFirstResponder:)
                                             to:nil from:self forEvent:nil];
    id obj = objc_getAssociatedObject(self, HFFormFirstResponderKey);
    objc_setAssociatedObject(self, HFFormFirstResponderKey, nil, OBJC_ASSOCIATION_ASSIGN);
    return obj;
}

- (void)setCurrentFirstResponder:(id)responder {
    objc_setAssociatedObject(self, HFFormFirstResponderKey, responder,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (void)findFirstResponder:(id)sender {
    [sender setCurrentFirstResponder:self];
}

@end
