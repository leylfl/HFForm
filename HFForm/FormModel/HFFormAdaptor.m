//
//  HFFormAdaptor.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/16.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormAdaptor.h"
#import "HFFormRowModel.h"
#import "HFFormSectionModel.h"
#import "HFFormBasicTableViewCell.h"

@interface HFFormAdaptor()

@end

@implementation HFFormAdaptor

- (void)setDatas:(NSMutableArray<HFFormSectionModel *> *)datas {
    if(datas == nil || datas.count == 0) return;
    _datas = datas;
    
    [self.tablebView reloadData];
}

#pragma mark - Public Method
- (void)insertSection:(NSIndexSet * _Nonnull)index {
    [self.tablebView beginUpdates];
    [self.tablebView insertSections:index withRowAnimation:UITableViewRowAnimationFade];
    [self.tablebView endUpdates];
}

- (void)insertRow:(NSIndexPath * _Nonnull)indexPath {
    [self insertRows:@[indexPath]];
}

- (void)insertRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths {
    [self.tablebView beginUpdates];
    [self.tablebView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tablebView endUpdates];
}

- (void)reloadRow:(NSIndexPath * _Nonnull)indexPath {
    [self reloadRows:@[indexPath]];
}

- (void)reloadRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths {
    [self.tablebView beginUpdates];
    [self.tablebView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tablebView endUpdates];
}

- (void)reloadHeight{
    [self.tablebView beginUpdates];
    [self.tablebView endUpdates];
}

- (void)deleteSection:(NSIndexSet * _Nonnull)index {
    [self.tablebView beginUpdates];
    [self.tablebView deleteSections:index withRowAnimation:UITableViewRowAnimationFade];
    [self.tablebView endUpdates];
}

- (void)deleteRow:(NSIndexPath * _Nonnull)indexPath {
    [self deleteRows:@[indexPath]];
}

- (void)deleteRows:(NSArray <NSIndexPath *>* _Nonnull)indexPaths {
    [self.tablebView beginUpdates];
    [self.tablebView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tablebView endUpdates];
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
    [self.tablebView endEditing:YES];
}


#pragma mark - Private Method
- (HFFormRowModel *)captureRowModelWithIndexPath:(NSIndexPath *)indexPath {
    HFFormSectionModel *section = self.datas[indexPath.section];
    return section.rows[indexPath.row];
}

#pragma mark - Lazy Method

@end
