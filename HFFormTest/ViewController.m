//
//  ViewController.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/15.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "ViewController.h"
#import "HFFormHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.height = APP_Height + 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self construcDatas];
}

- (void)construcDatas{
    HFFormSectionModel *section;
    HFFormRowModel *row;
    
    section = [HFForm section];
    row = [HFForm rowWithType:HFFormRowTypeDefault];
    row.title = @"姓名";
    row.placeholder = @"请输入学生姓名";
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeDefault];
    row.title = @"年龄";
    row.placeholder = @"请输入学生年龄";
    row.subfix = @"周岁";
    row.keyboardType = UIKeyboardTypeNumberPad;
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeOptions];
    row.title = @"性别";
    row.placeholder = @"请选择学生性别";
    row.subRowsHandler = ^{
        NSMutableArray *array = @[].mutableCopy;
        HFFormRowModel *relRow = [HFForm row];
        relRow.multiDatas = @[@"男",@"女"];
        [array addObject:relRow];
        return array;
    };
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeSwitch];
    row.title = @"是否本地户籍";
    row.value = @1;
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeDefault];
    row.title = @"家庭住址";
    row.placeholder = @"请输入学生家庭住址";
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeDatePicker];
    row.title = @"出生日期";
    row.placeholder = @"选择出生日期";
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeDatePicker];
    row.title = @"入学日期";
    row.placeholder = @"选择入学日期";
    [section appendRow:row];
    [self.form appendSection:section];
    
    section = [self getRelationSectionWithTitle:@"学生联系人1"];
    [self.form appendSection:section];
    
    section = [HFForm section];
    row = [HFForm rowWithType:HFFormRowTypeAddSection];
    row.title = @"添加联系人";
    WEAK_SELF;
    row.valueHandler = ^(id value) {
        STRONG_SELF;
        [self _addRelationShip];
    };
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeAlbum];
    row.title = @"学生照片";
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeText];
    row.title = @"学生评价";
    row.placeholder = @"请输入对学生的评价";
    row.subfix = @"至少输入100个字";
    row.settingsHandler = ^{
        return @{@"minCount": @100};
    };
    [section appendRow:row];
    
    [self.form appendSection:section];
    
    [self.form reloadData];
}

- (HFFormSectionModel *)getRelationSectionWithTitle:(NSString *)title {
    HFFormRowModel *row;
    
    HFFormSectionModel *section = [HFForm section];
    row = [HFForm rowWithType:HFFormRowTypeTitle];
    row.key = @"title";
    row.title = title;
    WEAK_SELF;
    row.valueHandler = ^(id value) {
        STRONG_SELF;
        [self _deleteRelationShipWith:section];
    };
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeDefault];
    row.title = @"联系人姓名";
    row.placeholder = @"请输入联系人姓名";
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeDefault];
    row.title = @"联系人电话";
    row.placeholder = @"请输入联系人电话";
    row.keyboardType = UIKeyboardTypePhonePad;
    [section appendRow:row];
    
    row = [HFForm rowWithType:HFFormRowTypeOptions];
    row.title = @"与学生关系";
    row.placeholder = @"请选择与学生的关系";
    row.subRowsHandler = ^{
        NSMutableArray *array = @[].mutableCopy;
        HFFormRowModel *relRow = [HFForm row];
        relRow.multiDatas = @[@"父亲", @"母亲", @"爷爷", @"奶奶", @"外公", @"外婆", @"其他亲戚"];
        [array addObject:relRow];
        return array;
    };
    [section appendRow:row];
    return section;
}

- (void)_addRelationShip {
    long i = [self.form obtainSectionCount];
    [self.form appendSection:[self getRelationSectionWithTitle:[NSString stringWithFormat:@"学生联系人%ld",i - 1]] atIndex:i - 1];
}

- (void)_deleteRelationShipWith:(HFFormSectionModel *)section {
     [self.form deleteSections:@[section]];
    
    NSArray *rows = [self.form obtainRowWithKey:@"title"];
    for (NSInteger idx = 0; idx < rows.count; idx++) {
        HFFormRowModel *titleRow = rows[idx];
        titleRow.title = [NSString stringWithFormat:@"学生联系人%ld", (long)(idx + 1)];
        [self.form reloadRow:titleRow];
    }
}


@end
