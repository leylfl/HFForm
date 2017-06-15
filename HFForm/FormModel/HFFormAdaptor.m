//
//  HFFormAdaptor.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/16.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormAdaptor.h"
#import "HFFormBasicTableViewCell.h"
#import "HFFormRefreshBaseView.h"

#import "UIScrollView+HFFormRefresh.h"

#import "HFFormRefreshEndTipView.h"

@interface HFFormAdaptor()

@property (nonatomic, strong) HFFormRefreshEndTipView *tipView;

@end

@implementation HFFormAdaptor

- (void)setDatas:(NSMutableArray<HFFormSectionModel *> *)datas {
    if(datas == nil || datas.count == 0) return;
    _datas = datas;
    
    [self.tableView reloadData];
}

- (void)setRefreshMode:(HFFormRefreshMode)refreshMode {
    _refreshMode = refreshMode;
    
    if (refreshMode & HFFormRefreshModeRefresh) {
        self.tableView.refreshEnable = YES;
    }
    
    if (refreshMode & HFFormRefreshModeLoadMore || refreshMode & HFFormRefreshModeLoadMoreManual) {
        self.tableView.loadMoreEnable = YES;
    }
}

#pragma mark - Public Method
- (void)insertSection:(NSIndexSet * _Nonnull)index {
    [self.tableView beginUpdates];
    [self.tableView insertSections:index withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)insertRow:(NSIndexPath * _Nonnull)indexPath {
    [self insertRows:@[indexPath]];
}

- (void)insertRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths {
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)reloadRow:(NSIndexPath * _Nonnull)indexPath {
    [self reloadRows:@[indexPath]];
}

- (void)reloadRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)reloadHeight{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)deleteSection:(NSIndexSet * _Nonnull)index {
    [self.tableView beginUpdates];
    [self.tableView deleteSections:index withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)deleteRow:(NSIndexPath * _Nonnull)indexPath {
    [self deleteRows:@[indexPath]];
}

- (void)deleteRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths {
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - TableView Delegate & TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(section < self.datas.count, @"section数组越界，请检查section数组里面数据数量是否正确");
    return self.datas[section].rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.datas[section].headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.datas[section].footerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFFormRowModel *row = [self captureRowModelWithIndexPath:indexPath];
    CGFloat height = row.height;
    if (height == 0 && [row.cell isSubclassOfClass:[HFFormBasicTableViewCell class]]) {
        height = [row.cell tableView:tableView heightWithRow:row indexPath:indexPath];
        row.height = height;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFFormRowModel *row = [self captureRowModelWithIndexPath:indexPath];
    
    HFFormBasicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:row.cellIdentifier];
    if (!cell) {
        cell = [[row.cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:row.cellIdentifier];
    }
    [cell updateData:row];
    
    if ([self.delegate respondsToSelector:@selector(setRowAtIndexPath:rowModel:tableViewCell:)]) {
        [self.delegate setRowAtIndexPath:indexPath rowModel:row tableViewCell:cell];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.refreshMode & HFFormRefreshModeLoadMore || self.refreshMode & HFFormRefreshModeLoadMoreManual) {
        HFFormRowModel *row = [self captureRowModelWithIndexPath:indexPath];
        if (row.type == HFFormRowTypeLoading) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(hasMoreData)]) {
            if([self.delegate hasMoreData]){
                tableView.tableFooterView = nil;
                tableView.footerView.hidden = NO;
                
                if(self.refreshMode & HFFormRefreshModeLoadMoreManual) return;
                
                if (indexPath.section == self.datas.count - 1) {
                    // 还有4个cell的时候加载更多
                    if (indexPath.row > self.datas[indexPath.section].rows.count - 4) {
                        [tableView.footerView beginLoadMore];
                    }
                }
            }else{
                tableView.tableFooterView = self.tipView;
                tableView.footerView.hidden = YES;
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.datas[section].headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.datas[section].headerTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.datas[section].footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.datas[section].footerTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFFormBasicTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:rowModel:tableViewCell:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath rowModel:self.datas[indexPath.section].rows[indexPath.row] tableViewCell:cell];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}


#pragma mark - Private Method
- (HFFormRowModel *)captureRowModelWithIndexPath:(NSIndexPath *)indexPath {
    HFFormSectionModel *section = self.datas[indexPath.section];
    return section.rows[indexPath.row];
}

#pragma mark - Lazy Method
- (HFFormRefreshEndTipView *)tipView {
    if (!_tipView) {
        _tipView = [[HFFormRefreshEndTipView alloc] init];
    }
    return _tipView;
}

@end
