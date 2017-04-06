//
//  HFFormImageBrowserVC.m
//  HFFormTest
//
//  Created by lifenglei on 17/4/6.
//  Copyright © 2017年 lifenglei. All rights reserved.
//

#import "HFFormImageBrowserVC.h"
#import "HFFormHelper.h"

#pragma mark - HFFormImageBrowserModel
@implementation HFFormImageBrowserModel

@end

#pragma mark - HFFormImageBrowserCell
@interface HFFormImageBrowserCell: UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) HFFormImageBrowserModel *model;

@end

@implementation HFFormImageBrowserCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setModel:(HFFormImageBrowserModel *)model {
    _model = model;
    
    if (model.image) {
        self.imageView.image = model.image;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame  = self.bounds;
}

@end

#pragma mark - HFFormImageBrowserVC

@interface HFFormImageBrowserVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HFFormImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.itemSize = CGSizeMake(APP_WIDTH, APP_Height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HFFormImageBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([HFFormImageBrowserCell class])];

    [self.view addSubview:_collectionView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidExecute)];
    [self.view addGestureRecognizer:tap];
    
     [self.collectionView setContentOffset:CGPointMake(APP_WIDTH * self.selectedIndex, 0.0)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.delegate numberOfImagesAtImageBrowser:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFFormImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HFFormImageBrowserCell class]) forIndexPath:indexPath];
    HFFormImageBrowserModel *model = [self.delegate imageBrowser:self itemAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tapDidExecute {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
