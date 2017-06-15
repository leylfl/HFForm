//
//  HFFormRefreshBaseView.h
//  haofangtuo
//
//  Created by lifenglei on 2017/6/8.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HFFormRefreshState) {
    HFFormRefreshStateNormal = 100,
    HFFormRefreshStateWillLoad,
    HFFormRefreshStateCanLoad,
    HFFormRefreshStateLoading
};

@interface HFFormRefreshBaseView : UIView

@property (nonatomic, assign) HFFormRefreshState state;

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)scrollViewDidChangeContentOffset:(CGPoint)contentOffset;
- (void)scrollViewDidChangeContentSize:(CGSize)contentSize;

@end

UIKIT_EXTERN NSString *const HFFormRefreshObserveOffsetKey;
UIKIT_EXTERN NSString *const HFFormRefreshObserveContentSizeKey;

UIKIT_EXTERN CGFloat const   HFFormRefreshHeaderHeight;
UIKIT_EXTERN CGFloat const   HFFormRefreshFooterHeight;

