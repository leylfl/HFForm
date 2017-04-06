//
//  HFFormOptionsTVC.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/20.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormOptionsTVC.h"
#import "HFFormOptionsView.h"

@implementation HFFormOptionsInterModel

@end

@interface HFFormOptionsTVC()

@property (nonatomic, assign) HFFormOptionsType type;

@end

@implementation HFFormOptionsTVC {
    UILabel             *_titleLabel;
    UILabel             *_contentLabel;
    HFFormOptionsView   *_pickerView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_contentLabel];
        
        _pickerView = [[HFFormOptionsView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, 240)];
        _pickerView.pickerView.delegate = self;
        _pickerView.pickerView.dataSource = self;
        __weak typeof(self)weakSelf = self;
        _pickerView.doneBlock = ^{
            __strong typeof(weakSelf)self = weakSelf;
            [self resignFirstResponder];
            
            [self _updateValue];
        };
        _pickerView.cancelBlock = ^{
            __strong typeof(weakSelf)self = weakSelf;
            [self resignFirstResponder];
        };
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return true;
}

- (BOOL)canResignFirstResponder {
    return true;
}

- (UIView *)inputView {
    return _pickerView;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    _titleLabel.text = row.title;
    _contentLabel.text = (row.titleHandler && [row.titleHandler() length] > 0) ? row.titleHandler() : (row.content ? [NSString stringWithFormat:@"%@",row.content]: row.placeholder);
    _contentLabel.textColor = row.content ? UIColorFromRGB(0x222222) : UIColorFromRGB(0xe1e1e1);
    
    // 构造数据
    [self _constructData];
    
    NSMutableArray *array = @[].mutableCopy;
    for (NSInteger i = 0; i < row.subRows.count; i++) {
        HFFormRowModel *subRow = row.subRows[i];
        if (subRow.value) {
            for (NSInteger j = 0; j < subRow.multiDatas.count; j++) {
                HFFormOptionsInterModel *model = subRow.multiDatas[j];
                if ([model.optionID isEqualToNumber:subRow.value]) {
                    [_pickerView.pickerView selectRow:j inComponent:i animated:NO];
                    [array addObject:model.optionValue];
                    break;
                }
            }
        }
    }
    if (array.count > 0) {
        self.row.content = [array componentsJoinedByString:@" "];
        _contentLabel.textColor = UIColorFromRGB(0x222222);
        switch (self.type) {
            case HFFormOptionsTypeNormal:{
                _contentLabel.text = self.row.content;
            }break;
                
            case HFFormOptionsTypeFloor:{
                NSString *content = [array componentsJoinedByString:@"/"];
                _contentLabel.text = [content stringByReplacingOccurrencesOfString:@"楼" withString:@""];
            }break;
                
            default:
                break;
        }
    }
}

- (void)_updateValue {
    NSMutableArray *values = @[].mutableCopy;
    for (NSInteger component = 0; component < self.row.subRows.count; component++) {
        NSInteger row = [_pickerView.pickerView selectedRowInComponent:component];
        HFFormRowModel *componentRow = self.row.subRows[component];
        if ([componentRow.multiDatas[row] isKindOfClass:[HFFormOptionsInterModel class]]) {
            HFFormOptionsInterModel *model = (HFFormOptionsInterModel *)componentRow.multiDatas[row];
            componentRow.value = model.optionID;
            [values addObject:model.optionValue];
        }
    }
    
    if(values.count > 0) {
        self.row.content = [values componentsJoinedByString:@" "];
        _contentLabel.textColor = UIColorFromRGB(0x222222);
        switch (self.type) {
            case HFFormOptionsTypeNormal:{
                _contentLabel.text = self.row.content;
            }break;
            
            case HFFormOptionsTypeFloor:{
                NSString *content = [values componentsJoinedByString:@"/"];
                _contentLabel.text = [content stringByReplacingOccurrencesOfString:@"楼" withString:@""];
            }break;
                
            default:
                break;
        }
    }
}

- (void)_constructData {
    if (self.row.subRows.count > 0) {
        for (long i = 0; i < self.row.subRows.count; i++) {
            HFFormRowModel *row  = self.row.subRows[i];
            NSArray *datas = row.multiDatas;
            row.valueHandler = ^(id value) {
                if (self.row.valueHandler) {
                    self.row.valueHandler(value);
                }
            };
            
            NSMutableArray *multiDatas = @[].mutableCopy;
            for (long j = 0; j < datas.count; j++) {
                if ([datas.firstObject isKindOfClass:[NSString class]]) {
                    HFFormOptionsInterModel *model = [[HFFormOptionsInterModel alloc] init];
                    model.optionID = @(j);
                    model.optionValue = datas[j];
                    [multiDatas addObject:model];
                }else if (![datas.firstObject isKindOfClass:[HFFormOptionsInterModel class]]){
                    NSObject *obj = datas[j];
                    HFFormOptionsInterModel *model = [[HFFormOptionsInterModel alloc] init];
                    if (self.row.displayID && self.row.displayValue) {
                        id value = [obj valueForKey:self.row.displayID];
                        model.optionID = @([NSString stringWithFormat:@"%@",value].integerValue);
                        model.optionValue = [obj valueForKey:self.row.displayValue];
                        [multiDatas addObject:model];
                    }
                }
            }
            if(multiDatas.count > 0) row.multiDatas = multiDatas;
        }
    }
}

#pragma mark - PickerView Delegate & DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.row.subRows.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.row.subRows[component].multiDatas.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.row.subRows[component].multiDatas[row] isKindOfClass:[HFFormOptionsInterModel class]]) {
        HFFormOptionsInterModel *model = (HFFormOptionsInterModel *)self.row.subRows[component].multiDatas[row];
        return model.optionValue;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 && self.type == HFFormOptionsTypeFloor) {
        if(row > [pickerView selectedRowInComponent:1]) {
            [pickerView selectRow:row inComponent:1 animated:YES];
        }
    }
    
    UILabel * label=  (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.textColor = [UIColor orangeColor];
    [pickerView reloadComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    label.font = [UIFont systemFontOfSize:14];
    if (!label) {
        label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
    }
    NSInteger selectedRow = [pickerView selectedRowInComponent:component];
    if (selectedRow == row) {
        label.textColor = [UIColor orangeColor];
    }else{
        label.textColor = UIColorFromRGB(0x878787);
    }
    HFFormOptionsInterModel *model = (HFFormOptionsInterModel *)self.row.subRows[component].multiDatas[row];
    label.text = model.optionValue;
    return label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left    = 16;
    _titleLabel.top     = 12;
    _titleLabel.width   = self.width - _titleLabel.left - 50;
    _titleLabel.height  = 24;
    
    _contentLabel.left      = _titleLabel.left;
    _contentLabel.top       = 38;
    _contentLabel.width     = _titleLabel.width;
    _contentLabel.height    = 28;
}

@end
