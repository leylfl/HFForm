//
//  HFFormSectionModel.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormSectionModel.h"
#import "HFFormRowModel.h"

@interface HFFormSectionModel()

@property (nonatomic, strong) NSMutableArray<HFFormRowModel *> *rows;

@end

@implementation HFFormSectionModel

- (instancetype)init {
    if (self = [super init]) {
        self.rows = [NSMutableArray array];
    }
    return self;
}

- (void)appendRow:(HFFormRowModel * _Nonnull)row {
    [_rows addObject:row];
}

- (void)appendRow:(HFFormRowModel * _Nonnull )row adIndex:(NSUInteger)index {
    NSAssert(index < self.rows.count, @"添加row的时候越界了");
    [_rows insertObject:row atIndex:index];
}

- (void)deleteRow:(HFFormRowModel * _Nonnull)row {
    [_rows removeObject:row];
}

@end
