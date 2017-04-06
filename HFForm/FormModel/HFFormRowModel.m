//
//  HFFormRowModel.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormRowModel.h"

@interface HFFormRowModel()

@property (nonatomic, strong) NSDictionary *settings;

@end

@implementation HFFormRowModel

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"value"];
}

- (id)init {
    if (self= [super init]) {
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.valueHandler) {
        self.valueHandler(change[NSKeyValueChangeNewKey]);
    }
}

- (NSString *)cellIdentifier {
    NSAssert(self.cell != nil, @"HFFormRowModel没有填写Cell类型");
    return NSStringFromClass(self.cell);
}

- (void)setTitleHandler:(HFFormRowTitleHandler)titleHandler {
    _titleHandler = titleHandler;
    if (titleHandler) {
        self.content = titleHandler();
    }
}

- (void)setSubRowsHandler:(HFFormRowValueSubRowsHandler)subRowsHandler {
    _subRowsHandler = [subRowsHandler copy];
    
    if (subRowsHandler) {
        self.subRows = subRowsHandler();
    }
}

- (void)setSettingsHandler:(HFFormRowSettingHandler)settingsHandler {
    _settingsHandler = [settingsHandler copy];
    
    if(settingsHandler) {
        self.settings = settingsHandler();
    }
}

- (void)appendSettings:(NSDictionary *)dict {
    if (self.settings.count > 0) {
        NSMutableDictionary *multiDict = [NSMutableDictionary dictionaryWithDictionary:self.settings];
        [multiDict addEntriesFromDictionary:dict];
        self.settings = multiDict;
    }else{
        self.settings = dict;
    }
}

@end
