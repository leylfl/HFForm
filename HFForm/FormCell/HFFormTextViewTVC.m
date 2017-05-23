//
//  HFFormTextViewTVC.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/23.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormTextViewTVC.h"

@interface HFFormTextViewTVC()<UITextViewDelegate>

@property (nonatomic, assign) NSUInteger maxCount;

@property (nonatomic, assign) NSUInteger minCount;

@property (nonatomic, assign) HFFormTextViewType textViewType;

@end

@implementation HFFormTextViewTVC {
    UILabel     *_titleLabel;
    UILabel     *_tipLabel;
    UITextView  *_textView;
    NSUInteger  _lastCharCount;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel             = [[UILabel alloc] init];
        _titleLabel.font        = [UIFont systemFontOfSize:14];
        _titleLabel.textColor   = UIColorFromRGB(0x555555);
        [self.contentView addSubview:_titleLabel];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font          = [UIFont systemFontOfSize:12];
        _tipLabel.textColor     = UIColorFromRGB(0x878787);
        [self.contentView addSubview:_tipLabel];
        
        _textView           = [[UITextView alloc] init];
        _textView.delegate  = self;
        _textView.textColor = UIColorFromRGB(0xe1e1e1);
        _textView.font      = [UIFont systemFontOfSize:16];
        _textView.scrollEnabled = NO;
        [self.contentView addSubview:_textView];
        
        self.textViewType = HFFormTextViewTypeTip;
        self.maxCount = NSUIntegerMax;
        self.minCount = 0;
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    if(row.value && [row.value isKindOfClass:[NSString class]] && [row.value length] == 0) row.value = nil; // 兼容后台即使没数据也会传个空字符串回来
    
    _titleLabel.text = row.title;
    _textView.text = (row.value && [row.value length] > 0) ? row.value : row.placeholder;
    _textView.textColor = (row.value && [row.value length] > 0) ? UIColorFromRGB(0x222222) : UIColorFromRGB(0xe1e1e1);
    
    _textView.editable = !row.disable;
    
    switch (self.textViewType) {
        case HFFormTextViewTypeNormal:{
            _tipLabel.hidden = YES;
        }break;
            
        case HFFormTextViewTypeTip:{
            _tipLabel.text = [NSString stringWithFormat:@"至少输入%lu个字", (unsigned long)self.minCount];
        }break;
            
        default:
            break;
    }
    
    if(self.maxCount == NSUIntegerMax || self.minCount == 0) _tipLabel.hidden = YES;
    
    [self _adjustHeight];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _textView.text = self.row.value ?: @"";
    
    _textView.textColor = UIColorFromRGB(0x222222);
    
    _titleLabel.textColor = UIColorFromRGB(0x6281c2);
    _tipLabel.textColor = UIColorFromRGB(0x6281c2);
    self.lineView.backgroundColor = UIColorFromRGB(0x6281c2);
    
    long count = (textView.text && textView.text.length > 0) ? textView.text.length : 0;
    _tipLabel.text = [NSString stringWithFormat:@"%ld/%lu", count,(unsigned long)self.maxCount];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _titleLabel.textColor = UIColorFromRGB(0x555555);
    self.lineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
    _tipLabel.textColor = UIColorFromRGB(0x878787);
    
    if (textView.text.length == 0){
        textView.textColor  = UIColorFromRGB(0xe1e1e1);
        textView.text       = self.row.placeholder;
        
        _tipLabel.text = [NSString stringWithFormat:@"至少输入%lu个字", (unsigned long)self.minCount];
        
        self.row.value = nil;
        
        [self setNeedsLayout];
        
        [self _adjustHeight];
        
        return;
    }
    
    self.row.value = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *highlightedPos = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && highlightedPos) {
        return;
    }
    
    if (textView.text.length > self.maxCount) {
        if (textView.text.length > _lastCharCount) {
            [HFFormHelper showNotice:[NSString stringWithFormat:@"输入字数不可超过%lu字",(unsigned long)self.maxCount]];
            
            textView.text = [textView.text substringToIndex:self.maxCount];
        }
    }
    
    _tipLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_textView.text.length, (unsigned long)self.maxCount];
    _lastCharCount = textView.text.length;
    // 自动偏移
    [self _adjustHeight];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left    = 16;
    _titleLabel.top     = 12;
    _titleLabel.width   = [HFFormHelper sizeWithText:_titleLabel.text font:_titleLabel.font maxSize:CGSizeMake(APP_WIDTH / 2, 20)].width + 5;
    _titleLabel.height  = 24;
    
    _tipLabel.width     = [HFFormHelper sizeWithText:_tipLabel.text font:_tipLabel.font maxSize:CGSizeMake(100, 20)].width + 10;
    _tipLabel.height    = 20;
    _tipLabel.left      = _titleLabel.right;
    _tipLabel.top       = 14;
    
    _textView.left      = 12;
    _textView.top       = _titleLabel.bottom;
    _textView.width     = self.width - 32;
    _textView.height    = [_textView sizeThatFits:CGSizeMake(self.width - 32, MAXFLOAT)].height;
}

- (void)_adjustHeight {
    CGFloat height = [_textView sizeThatFits:CGSizeMake(APP_WIDTH - 32, MAXFLOAT)].height;
    BOOL change = fabs((16 + 24 + height) - self.row.height) > 5; // 给予5的容错
    if (change) {
        self.row.height = 16 + 24 + height;
        if (self.row.reloadHandler) {
            self.row.reloadHandler(HFFormRefreshTypeHeight);
        }
    }
}

+ (CGFloat)tableView:(UITableView *)tableView heightWithRow:(HFFormRowModel *)row indexPath:(NSIndexPath *)indexPath {
    NSString *text = (row.value && [row.value isKindOfClass:[NSString class]] && [row.value length] > 0) ? row.value : row.placeholder;
    CGFloat height = [HFFormHelper sizeWithText:text font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(APP_WIDTH - 32 - 15, MAXFLOAT)].height + 2;
    return height + 16 + 24 + 16 > 76 ? height + 16 + 24 + 16 : 76;
}

@end
