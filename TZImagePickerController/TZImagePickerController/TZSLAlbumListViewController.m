//
//  TZSLAlbumListViewController.m
//  TZImagePickerController
//
//  Created by 柯磊 on 2018/11/6.
//  Copyright © 2018 谭真. All rights reserved.
//

#import "TZSLAlbumListViewController.h"
#import "TZImagePickerController.h"
#import "TZSLAlbumCell.h"
#import "TZAssetModel.h"
#import "TZImageManager.h"

@interface TZSLAlbumListViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat menuY;
@property (nonatomic, copy) void(^completeBlock)(TZAlbumModel *);
@property (nonatomic, copy) void(^dismissBlock)(void);
@property (nonatomic, strong) NSArray<TZAlbumModel *> *datas;
@end

#define kCellIdentifier @"MYCELL"

@implementation TZSLAlbumListViewController

+ (void)showInViewController:(UIViewController *)viewController menuY:(CGFloat)menuY datas:(NSArray<TZAlbumModel *> *)datas completeBlock:(void(^)(TZAlbumModel *))completeBlock dismissBlock:(void(^)(void))dismissBlock {
    TZSLAlbumListViewController *albumListVC = [[TZSLAlbumListViewController alloc] init];
    albumListVC.datas = datas;
    albumListVC.menuY = menuY;
    albumListVC.completeBlock = completeBlock;
    albumListVC.dismissBlock = dismissBlock;
    [albumListVC willMoveToParentViewController:viewController];
    [viewController addChildViewController:albumListVC];
    [viewController.view addSubview:albumListVC.view];
    [albumListVC didMoveToParentViewController:viewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.shadowView];
    [self.shadowView addSubview:self.collectionView];
    
    [self showMenu];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZSLAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.model = self.datas[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.completeBlock) {
        self.completeBlock(self.datas[indexPath.item]);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self closeAction];
    });
}

#pragma mark - public methods

#pragma mark - private methods

- (void)showMenu {
    CGFloat datasHeight = self.datas.count * (self.flowLayout.itemSize.height + self.flowLayout.sectionInset.top) + self.flowLayout.sectionInset.bottom;
    CGFloat maxHeight = self.view.bounds.size.height - self.menuY;
    
    self.shadowView.frame = CGRectMake([TZCommonTools tz_viewLeftMargin], self.menuY, self.view.bounds.size.width - [TZCommonTools tz_viewLeftMargin], MIN(datasHeight, maxHeight));
    self.collectionView.frame = self.shadowView.bounds;
    
    CGRect newFrame = self.shadowView.frame;
    newFrame.origin.y -= 20;
    self.shadowView.frame = newFrame;
    self.shadowView.alpha = 0;
    self.closeButton.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect newFrame = self.shadowView.frame;
        newFrame.origin.y = self.menuY;
        self.shadowView.frame = newFrame;
        self.shadowView.alpha = 1.0;
        self.closeButton.alpha = 1.0;
    }];
}

- (void)closeAction {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect newFrame = self.shadowView.frame;
        newFrame.origin.y -= 20;
        self.shadowView.frame = newFrame;
        self.shadowView.alpha = 0;
        self.closeButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self didMoveToParentViewController:nil];
    }];
}

#pragma mark - UI property

- (UIButton *)closeButton {
    if (!_closeButton) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = self.view.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.05];
        [view addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        _closeButton = view;
    }
    return _closeButton;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 4;
        _shadowView = view;
    }
    return _shadowView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        layout.minimumLineSpacing = layout.sectionInset.top;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(self.view.bounds.size.width - [TZCommonTools tz_viewLeftMargin] - layout.sectionInset.left - layout.sectionInset.right, 68);
        _flowLayout = layout;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = UIColor.clearColor;
        [view registerClass:TZSLAlbumCell.class forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView = view;
    }
    return _collectionView;
}

@end
