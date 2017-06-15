//
//  HFFormRefreshFooterView.m
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormRefreshFooterView.h"

#import "HFFormHelper.h"

#define LOADMORE_WILL_LOAD_POINT 10
#define LOADMORE_CRITICAL_POINT 88

@interface HFFormRefreshFooterView()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation HFFormRefreshFooterView

#pragma mark - Initializer
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.indicatorView];
        
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:12];
        self.tipLabel.textColor = [UIColor lightGrayColor];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.tipLabel];
    }
    return self;
}

#pragma mark - Public Method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.x      = 0;
    self.width  = APP_WIDTH;
    self.height = HFFormRefreshFooterHeight;
    self.top    = newSuperview.height;
}

- (void)setState:(HFFormRefreshState)state {
    super.state = state;
    
    self.tipLabel.hidden = NO;
    
    switch (state) {
        case HFFormRefreshStateNormal:{
            self.tipLabel.text = @"上拉加载更多...";
        }break;
            
        case HFFormRefreshStateWillLoad: {
            self.tipLabel.text = @"继续上拉加载更多...";
        }break;
            
        case HFFormRefreshStateCanLoad: {
            self.tipLabel.text = @"松手进行加载更多...";
        }break;
            
        case HFFormRefreshStateLoading: {
            self.tipLabel.hidden = YES;
        };
            
        default:
            break;
    }
}

- (void)beginLoadMore {
    if(self.loadMoreExecute) self.loadMoreExecute();
    [self.delegate loadMore];
    
    self.state = HFFormRefreshStateLoading;
    self.isLoading = YES;
    [self.indicatorView startAnimating];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, HFFormRefreshFooterHeight, 0);
    }];
}

- (void)endLoadMore {
    self.state = HFFormRefreshStateNormal;
    self.isLoading = NO;
    [self.indicatorView stopAnimating];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

- (void)scrollViewDidChangeContentOffset:(CGPoint)contentOffset {
    [super scrollViewDidChangeContentOffset:contentOffset];
    
    if(contentOffset.y < 0 || self.state == HFFormRefreshStateLoading) return;
    
    CGFloat melta = self.scrollView.contentSize.height - self.scrollView.height > 0 ? contentOffset.y - (self.scrollView.contentSize.height - self.scrollView.height) : contentOffset.y;
    if (melta > LOADMORE_WILL_LOAD_POINT && melta < LOADMORE_CRITICAL_POINT ) {
        self.state = HFFormRefreshStateWillLoad;
    }else if (melta > LOADMORE_CRITICAL_POINT && self.scrollView.isDragging && self.state != HFFormRefreshStateLoading) {
        self.state = HFFormRefreshStateCanLoad;
    }else if (melta > LOADMORE_CRITICAL_POINT && !self.scrollView.isDragging && self.state != HFFormRefreshStateLoading) {
        [self beginLoadMore];
    }
}

- (void)scrollViewDidChangeContentSize:(CGSize)contentSize {
    [super scrollViewDidChangeContentSize:contentSize];
    
    if(contentSize.height > 0) self.top = contentSize.height > self.scrollView.height ? contentSize.height : self.scrollView.height;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.indicatorView.center   = CGPointMake(self.width / 2, self.height / 2);
    
    self.tipLabel.width         = self.width;
    self.tipLabel.height        = self.height;
    self.tipLabel.center        = CGPointMake(self.width / 2, self.height / 2);
}

@end
