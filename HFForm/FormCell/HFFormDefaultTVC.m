//
//  HFFormDefaultTVC.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/16.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormDefaultTVC.h"
#import "HFFormRowModel.h"

@interface HFFormDefaultTVC()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UITextField   *contentTextField;
@property (nonatomic, strong) UILabel       *subfixLabel;

@end

@implementation HFFormDefaultTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromRGB(0x555555);
        [self.contentView addSubview:self.titleLabel];
        
        
        self.contentTextField = [[UITextField alloc] init];
        self.contentTextField.font = [UIFont systemFontOfSize:16];
        self.contentTextField.delegate = self;
        [self.contentView addSubview:self.contentTextField];
        
        self.subfixLabel = [[UILabel alloc] init];
        self.subfixLabel.font = [UIFont systemFontOfSize:16];
        self.subfixLabel.hidden = YES;
        self.subfixLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:self.subfixLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subfixLabelTap)];
        [self.subfixLabel addGestureRecognizer:tap];
    }
    return self;
}

- (void)subfixLabelTap {
    [self.contentTextField becomeFirstResponder];
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    self.titleLabel.text = row.title;
    self.contentTextField.attributedPlaceholder = (row.placeholder && row.placeholder.length > 0) ? [[NSAttributedString alloc] initWithString:row.placeholder attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xe1e1e1)}] : nil;
    self.contentTextField.text = (row.value && [NSString stringWithFormat:@"%@", row.value].length > 0)? [NSString stringWithFormat:@"%@", row.value] : nil;
    self.contentTextField.keyboardType = row.keyboardType;

    if (row.subfix.length > 0) {
        self.subfixLabel.hidden = NO;
        self.subfixLabel.text   = row.subfix;
    }
    
    self.contentTextField.enabled = !row.disable;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.left        = 16;
    self.titleLabel.top         = 12;
    self.titleLabel.width       = self.width - self.titleLabel.left - 50;
    self.titleLabel.height      = 24;
    
    self.contentTextField.left      = self.titleLabel.left;
    self.contentTextField.top       = 38;
    self.contentTextField.height    = 28;
    if (!self.contentTextField.editing && [self.row.value length] > 0) {
        self.contentTextField.width = [HFFormHelper sizeWithText:self.contentTextField.text font:self.contentTextField.font maxSize:CGSizeMake(self.width - 80, 25)].width + 7;
    }else{
        self.contentTextField.width     = self.titleLabel.width;
    }
    
    if (!self.contentTextField.editing && [self.row.value length] > 0 && self.row.subfix.length > 0) {
        self.subfixLabel.width = [HFFormHelper sizeWithText:self.subfixLabel.text font:self.subfixLabel.font maxSize:CGSizeMake(100, 25)].width + 5;
    }else{
        self.subfixLabel.width = 0;
    }
    self.subfixLabel.height     = self.contentTextField.height;
    self.subfixLabel.left       = self.contentTextField.right;
    self.subfixLabel.top        = self.contentTextField.top;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = self.row.value ?: @"";
    textField.textColor = UIColorFromRGB(0x222222);
    
    self.titleLabel.textColor = [UIColor orangeColor];
    self.lineView.backgroundColor = [UIColor orangeColor];
    
    [self setNeedsLayout];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        self.row.value = textField.text;
        
        [self setNeedsLayout];
    }else{
        textField.text = self.row.placeholder;
        textField.textColor = UIColorFromRGB(0xe1e1e1);
        
        self.row.value = nil;
    }
    
    self.titleLabel.textColor = UIColorFromRGB(0x555555);
    self.lineView.backgroundColor = UIColorFromRGB(0xe1e1e1);
}

@end
