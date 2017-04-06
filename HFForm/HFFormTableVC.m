//
//  HFFormTableVC.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormTableVC.h"
#import "HFFormAdaptor.h"
#import "HFFormHelper.h"
#import "UIResponder+HFForm.h"

#if DEBUG
#import "HFormOptimizeInfo.h"
#endif

@interface HFFormTableVC ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HFForm *form;

@end

@implementation HFFormTableVC

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.height = APP_Height - 44;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.form = [[HFForm alloc] init];
    self.form.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate         = self.form.adpator;
    self.tableView.dataSource       = self.form.adpator;
    self.form.adpator.tablebView    = self.tableView;
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#if DEBUG
    [HFormOptimizeInfo show];
#endif
}

- (void)dealloc {
#if DEBUG
    [HFormOptimizeInfo hide];
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)panAction:(UIGestureRecognizer *)recognnizer {
    [self.tableView endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    id responder = self.currentFirstResponder;
    if ([responder isKindOfClass:UIView.class] && [(UIView *)responder isDescendantOfView:self.tableView]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIView *responderView = (UIView *)responder;
            if ([responder isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                responderView = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
            }
            
            NSDictionary *keyboardInfo = [notification userInfo];
            CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            keyboardFrame = [self.tableView.window convertRect:keyboardFrame toView:self.tableView.superview];
            CGFloat inset = self.tableView.frame.origin.y + self.tableView.frame.size.height - keyboardFrame.origin.y;
            
            CGFloat offset = self.tableView.contentOffset.y;
            CGRect visibleRect = CGRectMake(0, offset, self.tableView.width, self.tableView.height - keyboardFrame.size.height);
            CGRect frame = [self.tableView convertRect:responderView.frame fromView:responderView.superview];
            BOOL needsScrolling = !CGRectContainsRect(visibleRect, frame);
            
            UIEdgeInsets scrollContentInset = self.tableView.contentInset;
            scrollContentInset.bottom = needsScrolling ? inset : MAX(inset, scrollContentInset.bottom);
            
            UIEdgeInsets scrollScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
            scrollScrollIndicatorInsets.bottom = inset;
            
            self.tableView.contentInset = scrollContentInset;
            self.tableView.scrollIndicatorInsets = scrollScrollIndicatorInsets;
            
            if (needsScrolling) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        CGRect frame = [self.tableView convertRect:responderView.frame fromView:responderView.superview];
                        [self.tableView scrollRectToVisible:CGRectInset(frame, 0, 0) animated:NO];
                    }];
                });
            }
        });
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets           = UIEdgeInsetsZero;
    NSDictionary *info                   = notification.userInfo;
    CGFloat animationDuration            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
    NSUInteger animationCurve            = ((NSNumber *)[info objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        self.tableView.contentInset          = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    } completion:nil];
}

@end
