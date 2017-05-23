//
//  HFFormCheckBoxTVC.m
//  haofangtuo
//
//  Created by lifenglei on 2017/5/12.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormCheckBoxTVC.h"

#import "HFFormOptionsInterModel.h"

@interface HFFormCheckBoxCVC: UICollectionViewCell

- (void)updateContent:(NSString *)content;

@end

@implementation HFFormCheckBoxCVC {
    UILabel     *_label;
    UILabel     *_arrowLabel;
    UIView      *_lineView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
        [self.contentView addSubview:_lineView];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = UIColorFromRGB(0x222222);
        [self.contentView addSubview:_label];
        
        _arrowLabel = [[UILabel alloc] init];
        _arrowLabel.font = [UIFont fontWithName:@"iconfont" size:20];
        _arrowLabel.text = @"选";
        _arrowLabel.textColor = RGB(63, 68, 98);
        _arrowLabel.hidden = YES;
        [self.contentView addSubview:_arrowLabel];
    }
    return self;
}

- (void)updateContent:(NSString *)content {
    _label.text = content;
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    
    _arrowLabel.hidden = !selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _label.frame = self.bounds;
    
    _arrowLabel.width   = 20;
    _arrowLabel.height  = 20;
    _arrowLabel.right   = self.width;
    _arrowLabel.top     = self.height / 2 - 10;

    _lineView.width     = self.width - 32;
    _lineView.height    = 0.5;
    _lineView.left      = 16;
    _lineView.top       = self.height - 0.5;
}

@end

@implementation HFFormCheckBoxTVC {
    UICollectionView    *_collectionView;
    UILabel             *_titleLabel;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x878787);
        [self.contentView addSubview:_titleLabel];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [self.contentView addSubview:_collectionView];
        
        [_collectionView registerClass:[HFFormCheckBoxCVC class] forCellWithReuseIdentifier:NSStringFromClass([HFFormCheckBoxCVC class])];
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    if(row.title && row.title.length > 0) _titleLabel.text = row.title;
    
    if(row.multiDatas.count > 0) {
        [self _dealWithData];
        [_collectionView reloadData];
    }
    
    if (row.value) {
        for (NSInteger idx = 0; idx < row.multiDatas.count; idx++) {
            HFFormOptionsInterModel *model = row.multiDatas[idx];
            NSString *string = [NSString stringWithFormat:@"%@",row.value];
            if (string.length > 0 && [model.optionID isEqualToString:string]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
                [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                break;
            }
        }
    }
}

#pragma mark - Cal Height
+ (CGFloat)tableView:(UITableView *)tableView heightWithRow:(HFFormRowModel *)row indexPath:(NSIndexPath *)indexPath {
    CGFloat height = 16 + 20 + 5 + (row.multiDatas.count * 44) + 12;
    return height;
}

#pragma mark - UICollection Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.row.multiDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HFFormCheckBoxCVC class]) forIndexPath:indexPath];
    if([self.row.multiDatas[indexPath.item] optionValue]) [(HFFormCheckBoxCVC *)cell updateContent:[self.row.multiDatas[indexPath.item] optionValue]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(APP_WIDTH - 32 , 44);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.row.value = [self.row.multiDatas[indexPath.item] optionID];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left    = 16;
    _titleLabel.top     = 24;
    _titleLabel.width   = self.width - _titleLabel.left - 20;
    _titleLabel.height  = 20;
    
    _collectionView.left    = 16;
    _collectionView.top     = _titleLabel.bottom + 2;
    _collectionView.width   = self.width - 32;
    _collectionView.height  = self.height - _collectionView.top - 12;
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

@end
