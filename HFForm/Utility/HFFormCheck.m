//
//  HFFormCheck.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormCheck.h"
#import "HFFormRowModel.h"

@implementation HFFormCheck

+ (NSError *(^)(HFFormRowModel *model))checkisNull {
    return ^(HFFormRowModel *model) {
        return model.value ? [NSError errorWithDomain:@"HFForm" code:0 userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"请输入%@",model.title]}] : nil;
    };
}

@end
