//
//  HFFormAlbumTVC.m
//  HFFormTest
//
//  Created by lifenglei on 17/3/17.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormAlbumTVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSBundle+HFForm.h"

#import "HFFormAlbumModel.h"

#import "HFFormImageBrowserVC.h"

#define kCount 3
#define kPicWidth  105
#define kPicHeight 79
#define THUMNAIL_WIDTH ([[UIScreen mainScreen] applicationFrame].size.width - 32 - (8 * (kCount - 1))) / kCount
#define THUMNAIL_HEIGHT ((CGFloat)kPicHeight/(CGFloat)kPicWidth) * THUMNAIL_WIDTH
#define THUMBNAIL_SIZE CGSizeMake(THUMNAIL_WIDTH, THUMNAIL_HEIGHT)

@interface HFFormAlbumTVC()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    HFFormAlbumCollectionViewCellDelegate,
    HFFormImageBrowserDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, assign) NSUInteger maxCount;

@property (nonatomic, assign) NSUInteger minCount;

@property (nonatomic, assign) NSUInteger selectedPhotoIndex; // 当前选中的图片

@property (nonatomic, strong) HFFormAlbumModel *photoAlbum;

@end

@implementation HFFormAlbumTVC

- (UIViewController *)rootController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

#pragma mark - Initialize
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromRGB(0x222222);
        [self.contentView addSubview:self.titleLabel];
    
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.font = [UIFont systemFontOfSize:12];
        self.subLabel.textColor = UIColorFromRGB(0x878787);
        [self.contentView addSubview:self.subLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.scrollEnabled = NO;
        [self.contentView addSubview:self.collectionView];
        
        [self.collectionView registerClass:[HFFormAlbumCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HFFormAlbumCollectionViewCell class])];
        [self.collectionView registerClass:[HFFormAlbumAddCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HFFormAlbumAddCollectionViewCell class])];
        
        self.maxCount = NSUIntegerMax;
        
        self.photoAlbum = [[HFFormAlbumModel alloc] init];
        self.photoAlbum.lineCount = @1;
    }
    return self;
}

- (void)updateData:(HFFormRowModel *)row {
    [super updateData:row];
    
    self.titleLabel.text = row.title;
    self.subLabel.text = row.placeholder;
    
    if(row.value) {
        self.photoAlbum = row.value;
        if (self.photoAlbum.photos.count >= 3 && self.photoAlbum.photos.count != self.maxCount) {
            [self _adjustRowHeight];
        }
        [self.collectionView reloadData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.left    = 16;
    self.titleLabel.top     = 12;
    self.titleLabel.width   = [HFFormHelper sizeWithText:self.titleLabel.text font:self.titleLabel.font maxSize:CGSizeMake(150, 20)].width + 5;
    self.titleLabel.height  = 24;
    
    self.subLabel.left      = self.titleLabel.right + 5;
    self.subLabel.top       = 12;
    self.subLabel.width     = [HFFormHelper sizeWithText:self.subLabel.text font:self.subLabel.font maxSize:CGSizeMake(self.width / 3, 24)].width + 5;
    self.subLabel.height    = 24;
    
    self.collectionView.top         = self.titleLabel.bottom + 10;
    self.collectionView.left        = 20;
    self.collectionView.width       = self.width - 30;
    self.collectionView.height      = self.height - self.collectionView.top - 15;
}

+ (CGFloat)tableView:(UITableView *)tableView heightWithRow:(HFFormRowModel *)row indexPath:(NSIndexPath *)indexPath {
    HFFormAlbumModel *model = row.value;
    model.lineCount = @(1);
    
    NSInteger maxCount = [row.settings[@"maxCount"] integerValue];
    CGFloat height = (THUMNAIL_HEIGHT) + 64;
    
    NSUInteger count = model.photos.count == maxCount ? model.photos.count : model.photos.count + 1;
    if (maxCount > 0 && model && count > 3) {
        NSUInteger col = ceil((CGFloat)count/ (CGFloat)3);
        model.lineCount = @(col);
        height = 65 + ((THUMNAIL_HEIGHT) * col) + 8 * (col - 1);
    }
    
    return height;
}

#pragma mark - UICollectionViewDelegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(self.photoAlbum.photos.count <= self.maxCount, @"添加图片的最大数量超过最大限制数了");
    return self.photoAlbum.photos.count == self.maxCount ? self.photoAlbum.photos.count : self.photoAlbum.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    if (indexPath.item < self.photoAlbum.photos.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HFFormAlbumCollectionViewCell class]) forIndexPath:indexPath];
        HFFormAlbumCollectionViewCell *albumCell = (HFFormAlbumCollectionViewCell *)cell;
        albumCell.delegate = self;
        albumCell.item = self.photoAlbum.photos[indexPath.row];
    }else if(indexPath.row == self.photoAlbum.photos.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HFFormAlbumAddCollectionViewCell class]) forIndexPath:indexPath];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return THUMBNAIL_SIZE;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[HFFormAlbumCollectionViewCell class]]) { // 如果是图片
        [self _openBigBrowserWithIndexPath:indexPath];
    }else if ([[collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[HFFormAlbumAddCollectionViewCell class]]) { // 点的是添加图片
        [self _openPhotoLibrary];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (originalImage == nil) {
        return;
    }
    
    
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *thumbnailImage = originalImage;
    
    HFFormAlbumPhotoModel *newHousePhoto = [[HFFormAlbumPhotoModel alloc] init];
    newHousePhoto.originalImage = originalImage;
    newHousePhoto.thumbnailImage = thumbnailImage;
    [self.photoAlbum.photos addObject:newHousePhoto];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self _updateData];
}

#pragma mark - HFFormImageBrowserDelegate
- (NSInteger)numberOfImagesAtImageBrowser:(HFFormImageBrowserVC *)imageBrowser {
    return self.photoAlbum.photos.count;
}

- (__kindof HFFormImageBrowserModel *)imageBrowser:(HFFormImageBrowserVC *)imageBrowser itemAtIndex:(NSUInteger)index {
    HFFormAlbumPhotoModel *photo = self.photoAlbum.photos[index];
    
    HFFormImageBrowserModel *image = [[HFFormImageBrowserModel alloc] init];
    image.image = photo.originalImage;
    image.imageURL = photo.imageURL;
    
    return image;
}

#pragma mark - HFFormAlbumCollectionViewCellDelegate
- (void)deletePhotoOfCell:(HFFormAlbumCollectionViewCell *)cell {
    self.selectedPhotoIndex = [self.collectionView indexPathForCell:cell].item;
    
    [self.photoAlbum.photos removeObjectAtIndex:self.selectedPhotoIndex];
    
    [self _updateData];
}

- (void)reloadCell {
    [self _updateData];
}

#pragma mark - Private Method
- (void)_updateData {
    self.row.value = self.photoAlbum;
    
    [self.collectionView reloadData];
    
    [self _adjustRowHeight];
}

- (void)_adjustRowHeight {
    // 如果相册模型里面的行数为空，说明是导入进来的数据，需要计算行数
    NSUInteger count = self.photoAlbum.photos.count == self.maxCount ? self.photoAlbum.photos.count : self.photoAlbum.photos.count + 1;
    NSUInteger col = ceil((CGFloat)count/ (CGFloat)3);
    
    if (col != self.photoAlbum.lineCount.integerValue) {
        self.photoAlbum.lineCount = @(col);
        
        self.row.height = 65 + ((THUMNAIL_HEIGHT) * col) + 8 * (col - 1);
        if (self.row.reloadHandler) {
            self.row.reloadHandler(HFFormRefreshTypeHeight);
        }
    }
}

- (void)_openPhotoLibrary {
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (photoLibraryAvailable && cameraAvailable) {
        [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self _presentPhotoLibraryController];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self _presentCameraController];
        }]];
    }else if (photoLibraryAvailable && !cameraAvailable) {
        [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self _presentPhotoLibraryController];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.rootController presentViewController:alert animated:YES completion:nil];
}

- (void)_openBigBrowserWithIndexPath:(NSIndexPath *)indexPath{
    // 进入查看大图
    HFFormImageBrowserVC *browser = [[HFFormImageBrowserVC alloc] init];
    browser.delegate = self;
    browser.selectedIndex = indexPath.row;
    [self.rootController presentViewController:browser animated:YES completion:nil];
}

// 打开相册
- (void)_presentPhotoLibraryController {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    BOOL granted = YES;
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        granted = NO;
    }
    
    if (granted) {
        UIImagePickerController *image = [[UIImagePickerController alloc] init];
        image.delegate = self;
        [self.rootController presentViewController:image animated:YES completion:nil];
        return;
    }
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"请在iPhone的\"设置-隐私-照片\"选项中，允许好房拓访问您的照片。"
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
}

// 打开相机
- (void)_presentCameraController {
    void (^handler)(BOOL granted) = ^(BOOL granted) {
        if (granted) {
            UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
            pickerViewController.allowsEditing = NO;
            pickerViewController.delegate = self;
            pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self.rootController presentViewController:pickerViewController animated:YES completion:nil];
        }else {
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:@"请在iPhone的\"设置-隐私-相机\"选项中，允许好房拓访问您的相机。"
                                       delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        }
    };
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:handler];
    
}

@end

#pragma mark - HFFormAlbumCollectionViewCell
@implementation HFFormAlbumCollectionViewCell {
    UIImageView                     *_imageView;
    UIButton                        *_deleButton;
    UILabel                         *_tipLabel;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"house_type_list_default"];
        _imageView.layer.cornerRadius = 5.f;
        
        _deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleButton.backgroundColor = [UIColor whiteColor];
        _deleButton.alpha = 0.7;
        _deleButton.clipsToBounds = YES;
        _deleButton.layer.cornerRadius = 8.f;
        _deleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_deleButton setTitle:@"删" forState:UIControlStateNormal];
        [_deleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_deleButton addTarget:self action:@selector(delePhoto) forControlEvents:UIControlEventTouchUpInside];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.hidden = YES;
        _tipLabel.font = [UIFont systemFontOfSize:APP_WIDTH == 320 ? 9 : 12];
        _tipLabel.text = @"建议上传横向图片";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        
        
        [self.contentView addSubview:_tipLabel];
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_deleButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    _imageView.height = (3.0 / 4.0) * _imageView.width;
    
    _tipLabel.top = _imageView.bottom + 8;
    _tipLabel.width = self.width;
    _tipLabel.left = 0;
    _tipLabel.height = 20;
    
    _deleButton.width = 20;
    _deleButton.height = 20;
    _deleButton.left = self.width - _deleButton.width - 4;
    _deleButton.top = 5;
    
    [self setNeedsDisplay];
}

- (void)delePhoto {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除图片？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         if ([self.delegate respondsToSelector:@selector(deletePhotoOfCell:)]) {
             [self.delegate deletePhotoOfCell:self];
         }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)setItem:(HFFormAlbumPhotoModel *)item {
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (item.originalImage) {
        _imageView.image = item.originalImage;
    }
    else { // 服务器端图片，加载URL
        
    }
    
    [self setNeedsLayout];
    
}

@end

#pragma mark - HFFormAlbumAddCollectionViewCell

@implementation HFFormAlbumAddCollectionViewCell {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [NSBundle albumPlaceholderImage];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end


