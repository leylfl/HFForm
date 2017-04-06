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
    CGFloat     _lastHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel             = [[UILabel alloc] init];
        _titleLabel.font        = [UIFont systemFontOfSize:14];
        _titleLabel.textColor   = UIColorFromRGB(0x555555);
        [self.contentView addSubview:_titleLabel];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font          = [UIFont systemFontOfSize:12];
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.textColor     = UIColorFromRGB(0x878787);
        [self.contentView addSubview:_tipLabel];
        
        _textView           = [[UITextView alloc] init];
        _textView.delegate  = self;
        _textView.textColor = UIColorFromRGB(0xe1e1e1);
        _textView.font      = [UIFont systemFontOfSize:16];
        _textView.scrollEnabled = NO;
        [self.contentView addSubview:_textView];
        
        self.textViewType = HFFormTextViewTypeNone;
        self.maxCount = NSUIntegerMax;
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    _titleLabel.text = row.title;
    _textView.text = row.value ?: row.placeholder;
    _textView.textColor = row.value ? UIColorFromRGB(0x222222) : UIColorFromRGB(0xe1e1e1);
    
    switch (self.textViewType) {
        case HFFormTextViewTypeNone:{
            _tipLabel.text = @"";
        }break;
            
        case HFFormTextViewTypeTip:{
            _tipLabel.text = [NSString stringWithFormat:@"至少输入%lu个字", (unsigned long)self.minCount];
        }break;
            
        case HFFormTextViewTVCLimited: {
            _tipLabel.text = [NSString stringWithFormat:@"0/%lu", (unsigned long)self.maxCount];
        };
            
        default:
            break;
    }
    
    [self setNeedsLayout];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _textView.text = self.row.value ?: @"";
    _textView.textColor = UIColorFromRGB(0x222222);
    
    _titleLabel.textColor = [UIColor orangeColor];
    self.lineView.backgroundColor = [UIColor orangeColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _titleLabel.textColor = UIColorFromRGB(0x555555);
    self.lineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
    
    if (textView.text.length == 0){
        textView.textColor  = UIColorFromRGB(0xe1e1e1);
        textView.text       = self.row.placeholder;
        return;
    }
    
    self.row.value = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView {
    // 如果是HFFormTextViewTVCLimited，需要做限制处理
    if (self.textViewType == HFFormTextViewTVCLimited) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *highlightedPos = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (selectedRange && highlightedPos) {
            return;
        }
        
        
        NSString *showText = [NSString stringWithFormat:@"%lu/%lu",MAX(0,textView.text.length), (unsigned long)self.maxCount];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:showText];
        if (textView.text.length > self.maxCount) {
            if (textView.text.length > _lastCharCount) {
                [HFFormHelper showNotice:[NSString stringWithFormat:@"输入字数不可超过%lu字",(unsigned long)self.maxCount]];
            }
            
            [attri setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:[showText rangeOfString:[NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length]]];
        }else{
            _tipLabel.textColor = [UIColor lightGrayColor];
        }
        _tipLabel.attributedText = attri;
        
        _lastCharCount = textView.text.length;
        
    }
    // 自动偏移
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.left    = 16;
    _titleLabel.top     = 12;
    _titleLabel.width   = self.width - _titleLabel.left - 100;
    _titleLabel.height  = 24;
    
    _tipLabel.width     = [HFFormHelper sizeWithText:_tipLabel.text font:_tipLabel.font maxSize:CGSizeMake(100, 20)].width + 5;
    _tipLabel.height    = 20;
    _tipLabel.left      = self.width - 16 - _tipLabel.width;
    _tipLabel.top       = 14;
    
    _textView.left      = 12;
    _textView.top       = _titleLabel.bottom;
    _textView.width     = self.width - 32;
    _textView.height    = [_textView sizeThatFits:CGSizeMake(self.width - 32, MAXFLOAT)].height;

    BOOL change = fabs((16 + 24 + _textView.height) - self.row.height) > 5; // 给予5的容错
    if (change) {
        self.row.height = 16 + 24 + _textView.height;
        
        if (self.row.reloadHandler) {
            self.row.reloadHandler(HFFormRefreshTypeHeight);
        }
    }
}

@end
