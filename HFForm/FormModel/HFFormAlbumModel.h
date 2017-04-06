//
//  HFFormAlbumModel.h
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFFormAlbumPhotoModel : NSObject

/**
 原始图
 */
@property (nonatomic, strong) UIImage *originalImage;

/**
 缩略图
 */
@property (nonatomic, strong) UIImage *thumbnailImage;

/**
 原始图的二进制数据
 */
@property (nonatomic, strong) NSData *data;

/**
 图片地址
 */
@property (nonatomic, copy) NSString *imageURL;

/**
 服务器返回给图片的key
 */
@property (nonatomic, copy) NSString *identifier;

- (NSString *)postDataFormat;

@end

@interface HFFormAlbumModel : NSObject

@property (nonatomic, strong) NSMutableArray <HFFormAlbumPhotoModel *> *photos;

@property (nonatomic, strong) NSNumber *lineCount;

- (NSString *)postDataFormat;

@end
