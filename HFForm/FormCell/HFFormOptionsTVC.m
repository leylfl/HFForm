//
//  HFFormOptionsTVC.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/20.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormOptionsTVC.h"
#import "HFFormOptionsView.h"

#import "HFFormOptionsInterModel.h"

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
        
        _pickerView = [[HFFormOptionsView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, iOS8 ? 240 : 260)];
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
    
    // 主要判断回填数据
    NSMutableArray *array = @[].mutableCopy;
    for (NSInteger i = 0; i < row.subRows.count; i++) {
        HFFormRowModel *subRow = row.subRows[i];
        if (subRow.value) {
            BOOL find = NO;
            for (NSInteger j = 0; j < subRow.multiDatas.count; j++) {
                HFFormOptionsInterModel *model = subRow.multiDatas[j];
                if ([model.optionID isEqualToString:[NSString stringWithFormat:@"%@", subRow.value]]) {
                    find = YES;
                    [_pickerView.pickerView selectRow:j inComponent:i animated:NO];
                    [_pickerView.pickerView reloadComponent:i];
                    [array addObject:model.optionValue];
                    break;
                }
            }
            if (!find && subRow.defaultSelectRow) {
                [_pickerView.pickerView selectRow:subRow.defaultSelectRow.integerValue - 1 inComponent:i animated:YES];
                [_pickerView.pickerView reloadComponent:i];
            }
            if (!find) {
                subRow.value = nil;
            }
        }else if (subRow.defaultSelectRow) {
            NSInteger j = subRow.defaultSelectRow.integerValue;
            [_pickerView.pickerView selectRow:j - 1 inComponent:i animated:YES];
            [_pickerView.pickerView reloadComponent:i];
        }else{
            [_pickerView.pickerView selectRow:0 inComponent:i animated:YES];
            [_pickerView.pickerView reloadComponent:i];
        }
    }
    if (array.count > 0) {
        if (row.formatter) {
            NSString *formatter = row.formatter;
            if (array.count == 1) {
                self.row.content = [NSString stringWithFormat:formatter, array[0]];
            }else if(array.count == 2) {
                self.row.content = [NSString stringWithFormat:formatter, array[0], array[1]];
            }else if (array.count == 3) {
                self.row.content = [NSString stringWithFormat:formatter, array[0], array[1], array[2]];
            }else if (array.count == 4) {
                self.row.content = [NSString stringWithFormat:formatter, array[0], array[1], array[2], array[3]];
            }
            
        }else{
            self.row.content = [array componentsJoinedByString:@" "];
        }
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
        if(componentRow.miniSelect && row < componentRow.miniSelect.integerValue) {
            if(componentRow.miniSelectError) [HFFormHelper showNotice:componentRow.miniSelectError];
            [_pickerView.pickerView selectRow:componentRow.miniSelect.integerValue - 1 inComponent:component animated:YES];
            [_pickerView.pickerView reloadComponent:component];
            break;
        }
        if ([componentRow.multiDatas[row] isKindOfClass:[HFFormOptionsInterModel class]]) {
            HFFormOptionsInterModel *model = (HFFormOptionsInterModel *)componentRow.multiDatas[row];
            componentRow.value = model.optionID;
            [values addObject:model.optionValue];
        }
    }
    
    if(values.count > 0) {
        if (self.row.formatter) {
            NSString *formatter = [self.row.formatter stringByReplacingOccurrencesOfString:@"AA" withString:@"%@"];
            if (values.count == 1) {
                self.row.content = [NSString stringWithFormat:formatter, values[0]];
            }else if(values.count == 2) {
                self.row.content = [NSString stringWithFormat:formatter, values[0], values[1]];
            }else if (values.count == 3) {
                self.row.content = [NSString stringWithFormat:formatter, values[0], values[1], values[2]];
            }else if (values.count == 4) {
                self.row.content = [NSString stringWithFormat:formatter, values[0], values[1], values[2], values[3]];
            }
            
        }else{
            self.row.content = [values componentsJoinedByString:@" "];
        }
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
                    model.optionID = datas[j];
                    model.optionValue = datas[j];
                    [multiDatas addObject:model];
                }else if (![datas.firstObject isKindOfClass:[HFFormOptionsInterModel class]]){
                    NSObject *obj = datas[j];
                    HFFormOptionsInterModel *model = [[HFFormOptionsInterModel alloc] init];
                    if (self.row.idKey && self.row.valueKey) {
                        id value = [obj valueForKey:self.row.idKey];
                        model.optionID = [NSString stringWithFormat:@"%@",value];
                        model.optionValue = [obj valueForKey:self.row.valueKey];
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
    if (self.type == HFFormOptionsTypeFloor) {
        if (component == 0 ) {
            if(row > [pickerView selectedRowInComponent:1]) {
                [pickerView selectRow:row inComponent:1 animated:YES];
                [pickerView reloadComponent:1];
            }
        }else{
            if(row < [pickerView selectedRowInComponent:0]) {
                [pickerView selectRow:[pickerView selectedRowInComponent:0] inComponent:1 animated:YES];
                [pickerView reloadComponent:1];
            }
        }
        
    }
    
    UILabel * label=  (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.textColor = [UIColor blackColor];//UIColorFromRGB(0x6281c2);
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
        label.textColor = [UIColor blackColor];//UIColorFromRGB(0x6281c2);
    }else{
        label.textColor = UIColorFromRGB(0x878787);
    }
    if (self.row.subRows.count > component && self.row.subRows[component].multiDatas.count > row) {
        HFFormOptionsInterModel *model = (HFFormOptionsInterModel *)self.row.subRows[component].multiDatas[row];
        label.text = model.optionValue;
    }
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
