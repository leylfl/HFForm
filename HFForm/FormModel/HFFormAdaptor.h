//
//  HFFormAdaptor.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/16.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HFFormRowModel.h"
#import "HFFormSectionModel.h"

@protocol HFFormAdaptorDelegate <NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSIndexPath * _Nullable)indexPath rowModel:(HFFormRowModel * _Nullable)row tableViewCell:(UITableViewCell * _Nullable)cell;

- (void)setRowAtIndexPath:(NSIndexPath * _Nullable)indexPath rowModel:(HFFormRowModel * _Nullable)row tableViewCell:(UITableViewCell * _Nullable)cell;

- (void)didDeselectRowAtIndexPath:(NSIndexPath * _Nullable)indexPath rowModel:(HFFormRowModel * _Nullable)row tableViewCell:(UITableViewCell * _Nullable)cell;

- (BOOL)hasMoreData;

@end

@interface HFFormAdaptor : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nonnull) UITableView *tableView;
@property (nonatomic, strong, nonnull) NSMutableArray<HFFormSectionModel *> *datas;
@property (nonatomic, weak, nullable) id<HFFormAdaptorDelegate> delegate;
@property (nonatomic, assign) HFFormRefreshMode refreshMode;
@property (nonatomic, assign) BOOL isRefreshingData;

- (void)insertSection:(NSIndexSet * _Nonnull)index;

- (void)insertRow:(NSIndexPath * _Nonnull)indexPath;

- (void)insertRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths;

- (void)reloadRow:(NSIndexPath * _Nonnull)indexPath;

- (void)reloadRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths;

- (void)reloadHeight;

- (void)deleteSection:(NSIndexSet * _Nonnull)index;

- (void)deleteRow:(NSIndexPath * _Nonnull)indexPath;

- (void)deleteRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths;

@end
