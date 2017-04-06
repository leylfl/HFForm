//
//  HFFormAlbumModel.m
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormAlbumModel.h"

@implementation HFFormAlbumPhotoModel

- (NSString *)postDataFormat
{
    return [NSString stringWithFormat:@"%@,jpg", self.identifier];
}

@end

@implementation HFFormAlbumModel

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSString *)postDataFormat
{
    NSMutableString *postString = [NSMutableString string];
    [self.photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HFFormAlbumPhotoModel *photo = obj;
        [postString appendFormat:@"%@;", [photo postDataFormat]];
    }];
    NSString *wStr = self.photos.count==0?@"":[postString substringToIndex:[postString length] - 1];
    return wStr;
}

@end
