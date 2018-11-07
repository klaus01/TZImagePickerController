//
//  TZSLAlbumListViewController.h
//  TZImagePickerController
//
//  Created by 柯磊 on 2018/11/6.
//  Copyright © 2018 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TZAlbumModel;
@interface TZSLAlbumListViewController : UIViewController
+ (void)showInViewController:(UIViewController *)viewController menuY:(CGFloat)menuY datas:(NSArray<TZAlbumModel *> *)datas completeBlock:(void(^)(TZAlbumModel *))completeBlock dismissBlock:(void(^)(void))dismissBlock;
@end

NS_ASSUME_NONNULL_END
