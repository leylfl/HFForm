//
//  HFormOptimizeInfo.m
//  haofangtuo
//
//  Created by lifenglei on 17/3/24.
//  Copyright © 2017年 平安好房. All rights reserved.
//

#import "HFormOptimizeInfo.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import "HFFormHelper.h"

@implementation HFormOptimizeInfo {
    UILabel         *_memoryLabel;
    UILabel         *_fpsLabel;
    UILabel         *_cpuLabel;
    CADisplayLink   *_link;
    NSTimeInterval  _lastTime;
    NSInteger       _count;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        
        _memoryLabel        = [self setupLabel];
        
        _fpsLabel           = [self setupLabel];
        
        _cpuLabel           = [self setupLabel];
        
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    }
    return self;
}

+ (instancetype)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelAlert;
    HFormOptimizeInfo *info = [self _getInfo];
    if(!info) info = [[HFormOptimizeInfo alloc] init];
    [window addSubview:info];
    return info;
}

+ (void)hide{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;
    HFormOptimizeInfo *info = [self _getInfo];
    [info removeFromSuperview];
}

+ (HFormOptimizeInfo *)_getInfo {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    HFormOptimizeInfo *info = nil;
    for (NSInteger idx = 0; idx < window.subviews.count; idx++) {
        if ([window.subviews[idx] isKindOfClass:[HFormOptimizeInfo class]]) {
            info = (HFormOptimizeInfo *)window.subviews[idx];
            break;
        }
    }
    return info;
}

- (UILabel *)setupLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10];
    [self addSubview:label];
    return label;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    _fpsLabel.text      = [NSString stringWithFormat:@"帧率：%.1ffps", fps];
    _memoryLabel.text   = [self usedMemory];
    _cpuLabel.text      = [self usedCPU];
}

- (NSString *)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"占用内存:%.1fMB",taskInfo.resident_size / 1024.0 / 1024.0];
}

- (NSString *)usedCPU
{
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    kern_return_t kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return nil;
    }
    
    CGFloat tot_cpu = 0;
    
    for (int j = 0; j < thread_count; j++)
        
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return nil;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (CGFloat)TH_USAGE_SCALE * 100.0;
        }
        
    }

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return [NSString stringWithFormat:@"CPU使用:%.1f%%",tot_cpu];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 30) / 3;
    
    _memoryLabel.left   = 30;
    _memoryLabel.top    = 0;
    _memoryLabel.width  = width;
    _memoryLabel.height = self.height;
    
    _fpsLabel.left      = _memoryLabel.right;
    _fpsLabel.top       = 0;
    _fpsLabel.width     = width;
    _fpsLabel.height    = self.height;
    
    _cpuLabel.left      = _fpsLabel.right;
    _cpuLabel.top       = 0;
    _cpuLabel.width     = width;
    _cpuLabel.height    = self.height;
}

- (void)dealloc {
    [_link invalidate];
}

@end
