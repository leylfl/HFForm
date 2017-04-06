//
//  HFFormDatePicker.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormDatePicker.h"
#import "HFFormHelper.h"

@interface HFFormCustomDatePicker : UIDatePicker

@property (nonatomic, strong) UIView *bgView;

@end

@implementation HFFormCustomDatePicker

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.frame = CGRectMake(0, 84.5, APP_WIDTH, 26.5);
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.subviews == 0) return;
    
    UIView *bgView = self.subviews.firstObject.subviews.firstObject;
    
    for (UIView *view in self.subviews.firstObject.subviews) {
        if (view.height < 1) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    
    BOOL hasBgView = NO;
    for (UIView *view in bgView.subviews) {
        if (view == self.bgView) {
            hasBgView = YES;
            break;
        }
    }
    if (!hasBgView) {
        [bgView insertSubview:self.bgView atIndex:0];
    }
}

@end

@interface HFFormDatePicker()

@property (nonatomic, strong) HFFormCustomDatePicker *datePicker;

@end

@implementation HFFormDatePicker{
    UIToolbar           *_toolBar;
    UIView              *_bgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.barTintColor = [UIColor whiteColor];
        [self addSubview:_toolBar];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_toolBar addSubview:_bgView];
        
        self.datePicker = [[HFFormCustomDatePicker alloc] init];
        self.datePicker.backgroundColor = RGB(248, 248, 248);
        [self addSubview:self.datePicker];
        
        [self.datePicker setValue:[UIColor redColor] forKey:@"highlightColor"];
        
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
    
    self.datePicker.left    = 0;
    self.datePicker.top     = 44;
    self.datePicker.width   = self.width;
    self.datePicker.height  = self.height - 44;
    
    _bgView.frame = _toolBar.bounds;
}

@end
