//
//  HFFormOptionsView.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/20.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFormPickerView.h"

typedef void(^HFFormOptionsDoneHandler)();
@interface HFFormOptionsView : UIView

@property (nonatomic, strong, readonly) HFFormPickerView *pickerView;

@property (nonatomic, copy) HFFormOptionsDoneHandler doneBlock;

@property (nonatomic, copy) HFFormOptionsDoneHandler cancelBlock;

@end
