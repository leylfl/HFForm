//
//  HFFormTextViewTVC.h
//  haofangtuo
//
//  Created by lifenglei on 17/3/23.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormBasicTableViewCell.h"

typedef NS_ENUM(NSUInteger, HFFormTextViewType) {
    HFFormTextViewTypeNone = 100, // 右上方空
    HFFormTextViewTypeTip,        // 右上方给提示，比如：最大几个字
    HFFormTextViewTVCLimited        // 右上方显示计算字数的提示，比如: 20/100
};

@interface HFFormTextViewTVC : HFFormBasicTableViewCell

@end
