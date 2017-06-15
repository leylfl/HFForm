//
//  HFFormRefreshBaseView.m
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormRefreshBaseView.h"
#import "UIScrollView+HFFormRefresh.h"

@interface HFFormRefreshBaseView()

@property (nonatomic, assign) CGFloat originContentInsetTop;

@end

@implementation HFFormRefreshBaseView

#pragma mark - Initializer
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.state = HFFormRefreshStateNormal;
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview || ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    if (newSuperview == self.scrollView) return;
    
    // 清除旧控件上的监听
    if(self.scrollView) [self _removeObserve];
    
    self.scrollView = (UIScrollView *)newSuperview;
    self.scrollView.originContentTop = self.scrollView.contentInset.top;
    
    [self _addObserve];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:HFFormRefreshObserveOffsetKey] && [object isKindOfClass:[UIScrollView class]]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [self scrollViewDidChangeContentOffset:contentOffset];
    }else  if ([keyPath isEqualToString:HFFormRefreshObserveContentSizeKey] && [object isKindOfClass:[UIScrollView class]]) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        [self scrollViewDidChangeContentSize:contentSize];
    }
}

#pragma mark - Public Method
- (void)scrollViewDidChangeContentOffset:(CGPoint)contentOffset {
}

- (void)scrollViewDidChangeContentSize:(CGSize)contentSize {
    
}

#pragma mark - Private Method
- (void)_addObserve {
    [self.scrollView addObserver:self forKeyPath:HFFormRefreshObserveOffsetKey options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:HFFormRefreshObserveContentSizeKey options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_removeObserve {
    [self.scrollView removeObserver:self forKeyPath:HFFormRefreshObserveOffsetKey];
    [self.scrollView removeObserver:self forKeyPath:HFFormRefreshObserveContentSizeKey];
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
}

@end

NSString *const HFFormRefreshObserveOffsetKey       = @"contentOffset";
NSString *const HFFormRefreshObserveContentSizeKey  = @"contentSize";
CGFloat   const HFFormRefreshHeaderHeight           = 60;
CGFloat   const HFFormRefreshFooterHeight           = 44;
