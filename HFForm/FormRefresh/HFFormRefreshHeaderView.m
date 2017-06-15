//
//  HFFormRefreshHeaderView.m
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormRefreshHeaderView.h"
#import "UIScrollView+HFFormRefresh.h"
#import "HFFormHelper.h"
#import "NSBundle+HFForm.h"

#pragma mark - HFFormRefreshHeaderDragView
@interface HFFormRefreshHeaderDragView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, assign) BOOL isLoading;

@property (assign, nonatomic) CGFloat offset;

- (void)startAnimation;

- (void)stopAnimation;

@end

@implementation HFFormRefreshHeaderDragView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithImage:[NSBundle loadAppleImage]];
        [self addSubview:self.imageView];
        
        self.loadingView = [[UIImageView alloc] initWithImage:[NSBundle loadingCircleImage]];
        [self addSubview:self.loadingView];
        
        self.circleLayer = [CAShapeLayer layer];
        self.circleLayer.strokeColor = UIColorFromRGB(0xcccccc).CGColor;
        self.circleLayer.lineWidth = 2.5;
        self.circleLayer.fillColor = [UIColor clearColor].CGColor;
        self.circleLayer.strokeEnd = 0.0f;
        self.circleLayer.strokeStart = 0.0f;
        
        [self.layer addSublayer:self.circleLayer];
    }
    
    return self;
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    
    if (!self.isLoading) {
        self.circleLayer.hidden = NO;
        self.circleLayer.strokeStart = 0.f;
        self.circleLayer.strokeEnd = fabs(offset) / self.loadingView.image.size.height;
    }else{
        self.circleLayer.hidden = YES;
        self.circleLayer.strokeEnd = 0.0f;
    }
    
}

- (void)startAnimation
{
    self.loadingView.alpha = 1.0;
    self.circleLayer.hidden = YES;
    self.isLoading = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue         = @(0);
    animation.toValue           = @(2 * M_PI);
    animation.duration          = 0.6f;
    animation.repeatCount       = INT_MAX;
    
    [self.loadingView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

- (void)stopAnimation
{
    [self.loadingView.layer removeAllAnimations];
    self.loadingView.alpha = 0.0;
    self.isLoading = NO;
    self.circleLayer.hidden = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.width  = self.imageView.image.size.width;
    self.imageView.height = self.imageView.image.size.height;
    self.imageView.center = CGPointMake(self.width / 2, self.height / 2);
    
    self.loadingView.width  = self.loadingView.image.size.width;
    self.loadingView.height = self.loadingView.image.size.height;
    self.loadingView.center = self.imageView.center;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:self.loadingView.frame];
    self.circleLayer.path = bezierPath.CGPath;
}

@end

#pragma mark - HFFormRefreshHeaderView
@interface HFFormRefreshHeaderView()

@property (nonatomic, strong) HFFormRefreshHeaderDragView *dragView;

@end

@implementation HFFormRefreshHeaderView

#pragma mark Initializer
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dragView = [[HFFormRefreshHeaderDragView alloc] init];
        [self addSubview:self.dragView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.frame = CGRectMake(0, self.scrollView.originContentTop - HFFormRefreshHeaderHeight, APP_WIDTH, HFFormRefreshHeaderHeight);
}

#pragma mark Public Method
- (void)scrollViewDidChangeContentOffset:(CGPoint)contentOffset {
    [super scrollViewDidChangeContentOffset:contentOffset];
    
    // 下拉过程忽略
    if(contentOffset.y > 0 || self.state == HFFormRefreshStateLoading) return;
    
    if (fabs(contentOffset.y) > 0 + self.scrollView.originContentTop && fabs(contentOffset.y) < 40 + self.scrollView.originContentTop) {
        self.state = HFFormRefreshStateNormal;
        
        self.dragView.loadingView.alpha = 0;
    }else if (fabs(contentOffset.y) > 40 + self.scrollView.originContentTop && fabs(contentOffset.y) < 85 + self.scrollView.originContentTop) {
        self.state = HFFormRefreshStateWillLoad;
        
        self.dragView.offset = fabs(contentOffset.y) - (40 + self.scrollView.originContentTop);
    }else if (fabs(contentOffset.y) > HFFormRefreshHeaderHeight + self.scrollView.originContentTop && !self.scrollView.isDragging) {
        if(self.refreshExecute && self.state != HFFormRefreshStateLoading) {
            // 回调数据，提供了两种方式
            self.refreshExecute();
            [self.delegate refreshData];
            
            [self.dragView startAnimation];
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(HFFormRefreshHeaderHeight + self.scrollView.originContentTop, 0, 0, 0)];
            }];
        }
        self.state = HFFormRefreshStateLoading;
    }
}

- (void)endRefresh {
    self.state = HFFormRefreshStateNormal;
    [self.dragView stopAnimation];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.originContentTop, 0, 0, 0)];
    }];
}

- (BOOL)isLoading {
    return self.dragView.isLoading;
}

#pragma mark Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.dragView.frame = self.bounds;
}

@end
