//
//  HFFormAdaptor.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/16.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HFFormRowModel, HFFormSectionModel;

@protocol HFFormAdaptorDelegate <NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSIndexPath * _Nullable)indexPath rowModel:(HFFormRowModel * _Nullable)row tableViewCell:(UITableViewCell * _Nullable)cell;

- (void)setRowAtIndexPath:(NSIndexPath * _Nullable)indexPath rowModel:(HFFormRowModel * _Nullable)row tableViewCell:(UITableViewCell * _Nullable)cell;

@end

@interface HFFormAdaptor : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nonnull) UITableView *tablebView;
@property (nonatomic, strong, nonnull) NSMutableArray<HFFormSectionModel *> *datas;
@property (nonatomic, weak, nullable) id<HFFormAdaptorDelegate> delegate;

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
