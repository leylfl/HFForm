//
//  HFFormDatePicker.h
//  haofangtuo
//
//  Created by lifenglei on 17/3/22.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HFFormDatePickerDoneHandler)();
@interface HFFormDatePicker : UIView

@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

@property (nonatomic, copy) HFFormDatePickerDoneHandler doneBlock;

@property (nonatomic, copy) HFFormDatePickerDoneHandler cancelBlock;

@end
