//
//  HFFormOptionsView.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/20.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormOptionsView.h"
#import "HFFormHelper.h"

@interface HFFormOptionsView()

@property (nonatomic, strong) HFFormPickerView *pickerView;

@end

@implementation HFFormOptionsView {
    UIToolbar           *_toolBar;
    UIView              *_bgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.barTintColor = [UIColor whiteColor];
        [self addSubview:_toolBar];
        
        self.pickerView = [[HFFormPickerView alloc] init];
        [self addSubview:self.pickerView];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_toolBar addSubview:_bgView];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        doneItem.tintColor = [UIColor orangeColor];
        cancelItem.tintColor = UIColorFromRGB(0x222222);
        [_toolBar setItems:@[cancelItem, spaceItem, doneItem]];
    }
    return self;
}

- (void)doneAction:(UIBarButtonItem *)item {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

- (void)cancelAction:(UIBarButtonItem *)item {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _toolBar.left   = 0;
    _toolBar.top    = 0;
    _toolBar.width  = self.width;
    _toolBar.height = 44;
    
    _pickerView.left    = 0;
    _pickerView.top     = 44;
    _pickerView.width   = self.width;
    _pickerView.height  = self.height - 44;
    
    _bgView.frame = _toolBar.bounds;
}

@end
