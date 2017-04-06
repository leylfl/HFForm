//
//  HFFormAlbumTVC.h
//  HFFormTest
//
//  Created by lifenglei on 17/3/17.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormBasicTableViewCell.h"

@class HFFormAlbumCollectionViewCell, HFFormAlbumPhotoModel;

#pragma mark HFFormAlbumCollectionViewCell
@protocol HFFormAlbumCollectionViewCellDelegate <NSObject>

- (void)deletePhotoOfCell:(HFFormAlbumCollectionViewCell *)cell;

- (void)reloadCell;

@end

@interface HFFormAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<HFFormAlbumCollectionViewCellDelegate> delegate;

@property (nonatomic, weak) HFFormAlbumPhotoModel *item;

@end

#pragma mark HFFormAlbumAddCollectionViewCell
@interface HFFormAlbumAddCollectionViewCell : UICollectionViewCell

@end

#pragma mark HFFormAlbumTVC
@interface HFFormAlbumTVC : HFFormBasicTableViewCell

@end
