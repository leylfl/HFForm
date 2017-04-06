//
//  HFFormOptionsTVC.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/20.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormBasicTableViewCell.h"

typedef NS_ENUM(NSUInteger, HFFormOptionsType){
    HFFormOptionsTypeNormal = 0,
    HFFormOptionsTypeFloor
};

@interface HFFormOptionsInterModel : NSObject

@property (nonatomic, copy)  NSString *optionValue;
@property (nonatomic, strong) NSNumber *optionID;

@end

@interface HFFormOptionsTVC : HFFormBasicTableViewCell<UIPickerViewDelegate, UIPickerViewDataSource>

@end
