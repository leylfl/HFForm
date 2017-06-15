//
//  HFFormTagsTVC.m
//  haofangtuo
//
//  Created by lifenglei on 2017/5/12.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormTagsTVC.h"

#import "HFFormOptionsInterModel.h"
@interface HFFormTagsTVC()

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *showH5;

@end

@implementation HFFormTagsTVC {
    UILabel  *_titleLabel;
    UILabel  *_subLabel;
    UIButton *_tipButton;
    
    NSMutableArray *_datas;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x878787);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _subLabel = [[UILabel alloc] init];
        _subLabel.textColor = UIColorFromRGB(0x878787);
        _subLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_subLabel];
        
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_tipButton setTitleColor:UIColorFromRGB(0x6281c2) forState:UIControlStateNormal];
        [_tipButton addTarget:self action:@selector(tipClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_tipButton];
        
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    if(row.title) _titleLabel.text = row.title;
    if(row.subfix) _subLabel.text = row.subfix;
    
    if(self.name) [_tipButton setTitle:self.name forState:UIControlStateNormal];

    [self _dealWithData];
    [self _constructButtons];
}

- (void)tagClick:(UIButton *)button {
    button.selected = !button.selected;
    
    HFFormOptionsInterModel *model = self.row.multiDatas[button.tag];
    
    if (button.selected) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.layer.borderColor = [UIColor orangeColor].CGColor;
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_datas addObject:model.optionID];
    }else{
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.borderColor = UIColorFromRGB(0x878787).CGColor;
        [button setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
        if ([_datas containsObject:model.optionID]) {
            [_datas removeObject:model.optionID];
        }
    }
    if(_datas.count > 0) self.row.value = [_datas componentsJoinedByString:@","];
    else if(self.row.value && _datas.count == 0) self.row.value = nil;
}

- (void)tipClick {
    if(self.showH5 && [self.showH5 hasPrefix:@"http"]) {
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left    = 16;
    _titleLabel.top     = 24;
    _titleLabel.width   = [HFFormHelper sizeWithText:_titleLabel.text font:_titleLabel.font maxSize:CGSizeMake(APP_WIDTH - 32, 20)].width + 5;
    _titleLabel.height  = 20;
    
    _subLabel.left          = _titleLabel.right + 5;
    _subLabel.top           = _titleLabel.top;
    _subLabel.width         = self.width - _subLabel.left - 80;
    _subLabel.height        = 20;
    
    _tipButton.width        = [HFFormHelper sizeWithText:_tipButton.titleLabel.text font:_tipButton.titleLabel.font maxSize:CGSizeMake(self.width / 3, 20)].width +5;
    _tipButton.height       = 20;
    _tipButton.right        = self.width - 16;
    _tipButton.top          = _subLabel.top;
}

+ (CGFloat)tableView:(UITableView *)tableView heightWithRow:(HFFormRowModel *)row indexPath:(NSIndexPath *)indexPath {
    CGFloat height = 16 + 20 + 5 + (ceil(row.multiDatas.count * 0.3) * (32 + 12)) + 32;
    return height;
}

#pragma mark - Private Method
- (void)_dealWithData {
    NSArray *datas = self.row.multiDatas;
    NSMutableArray *tmpDatas = @[].mutableCopy;
    if ([datas.firstObject isKindOfClass:[NSString class]]) {
        for (NSInteger idx = 0; idx < datas.count; idx++) {
            HFFormOptionsInterModel *interModel = [[HFFormOptionsInterModel alloc] init];
            interModel.optionValue = datas[idx];
            interModel.optionID    = datas[idx];
            [tmpDatas addObject:interModel];
        }
        self.row.multiDatas = tmpDatas;
    }else if(![datas.firstObject isKindOfClass:[HFFormOptionsInterModel class]]){
        NSAssert(self.row.idKey && self.row.idKey.length > 0 && self.row.valueKey && self.row.valueKey.length > 0, @"HFFormCheckBoxCVC 您选择了传模型进来，但没有给idKey或valueKey赋值");
        for (NSInteger idx = 0; idx < datas.count; idx++) {
            HFFormOptionsInterModel *interModel = [[HFFormOptionsInterModel alloc] init];
            interModel.optionValue  = [datas[idx] objectForKey:self.row.valueKey];
            interModel.optionID     = [datas[idx] objectForKey:self.row.idKey];
            [tmpDatas addObject:interModel];
        }
        self.row.multiDatas = tmpDatas;
    }
}

- (void)_constructButtons {
    NSArray *array = nil;
    if(self.row.value && [self.row.value isKindOfClass:[NSString class]] && [self.row.value length] > 0) {
        NSString *string = self.row.value;
        array = [string componentsSeparatedByString:@","];
    }
    for (NSInteger idx = 0; idx < self.row.multiDatas.count; idx++) {
        HFFormOptionsInterModel *model = self.row.multiDatas[idx];
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.clipsToBounds = YES;
        button.layer.borderWidth = 1.f;
        button.tag = idx;
        button.layer.borderColor = UIColorFromRGB(0x878787).CGColor;
        [button setTitle:model.optionValue forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        CGFloat width = (APP_WIDTH - 32 - 20) * 0.3;
        CGFloat height = 32;
        NSInteger col = idx / 3;
        CGFloat x = ((idx + 3) % 3) * (width + 20) + 20;
        CGFloat y = col * (height + 12) + 68;
        button.frame = CGRectMake(x, y, width, height);
        button.layer.cornerRadius = height / 2;
        
        if(array && array.count > 0) {
            for (NSString *value in array) {
                if ([value isEqualToString:model.optionID]) {
                    [self tagClick:button];
                    break;
                }
            }
        }
    }
}

@end
