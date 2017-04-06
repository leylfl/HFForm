//
//  HFFormImageBrowserVC.h
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFFormImageBrowserVC;

@interface HFFormImageBrowserModel : NSObject

@property (nonatomic, copy) NSString *imageURL;

@property (nonatomic, strong) UIImage *image;

@end

@protocol HFFormImageBrowserDelegate <NSObject>

- (NSInteger)numberOfImagesAtImageBrowser:(HFFormImageBrowserVC *)imageBrowser;
- (__kindof HFFormImageBrowserModel *)imageBrowser:(HFFormImageBrowserVC *)imageBrowser itemAtIndex:(NSUInteger)index;

@optional
- (void)imageBrowser:(HFFormImageBrowserVC *)imageBrowser didRemoveImageAt:(NSInteger)index;

@end

@interface HFFormImageBrowserVC : UIViewController

@property (nonatomic, weak) id<HFFormImageBrowserDelegate>delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
