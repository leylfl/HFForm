//
//  HFFormTextViewTVC.h
//  haofangtuo
//
//  Created by lifenglei on 17/3/23.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFFormBasicTableViewCell.h"

typedef NS_ENUM(NSUInteger, HFFormTextViewType) {
    HFFormTextViewTypeTip       = 100, // 右上方给提示，比如：最大几个字
    HFFormTextViewTypeNormal            // 右上方空
};

@interface HFFormTextViewTVC : HFFormBasicTableViewCell

@end
