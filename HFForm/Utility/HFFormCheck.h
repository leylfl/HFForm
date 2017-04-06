//
//  HFFormCheck.h
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HFFormRowModel;

@interface HFFormCheck : NSObject

+ (NSError * (^)(HFFormRowModel *model))checkisNull;

@end
