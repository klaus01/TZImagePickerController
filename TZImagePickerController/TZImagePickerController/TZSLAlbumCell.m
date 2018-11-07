//
//  TZSLAlbumCell.m
//  TZImagePickerController
//
//  Created by 柯磊 on 2018/11/6.
//  Copyright © 2018 谭真. All rights reserved.
//

#import "TZSLAlbumCell.h"
#import "TZAssetModel.h"
#import "TZImagePickerController.h"

@interface TZSLAlbumCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation TZSLAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.arrowImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize cellSize = self.contentView.bounds.size;
    self.imageView.frame = CGRectMake(0, 0, cellSize.height, cellSize.height);
    self.arrowImageView.frame = CGRectMake(cellSize.width - self.arrowImageView.frame.size.width, (cellSize.height - self.arrowImageView.frame.size.height) / 2.0, self.arrowImageView.frame.size.width, self.arrowImageView.frame.size.height);
    CGFloat x = CGRectGetMaxX(self.imageView.frame) + 13;
    self.nameLabel.frame = CGRectMake(x, 0, CGRectGetMinX(self.arrowImageView.frame) - 10 - x, 20);
    self.countLabel.frame = CGRectMake(x, (cellSize.height - 17) / 2.0, self.nameLabel.frame.size.width, 17);
}

#pragma mark - public methods

- (void)setModel:(TZAlbumModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.countLabel.text = [NSString stringWithFormat:@"%zd", model.count];
    [[TZImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        self.imageView.image = postImage;
    }];
}

#pragma mark - private methods

#pragma mark - UI property

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        _imageView = view;
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = [UIColor colorWithWhite:0x18 / 255.0 alpha:1.0];
        _nameLabel = view;
    }
    return _nameLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = [UIColor colorWithWhite:0x9B / 255.0 alpha:1.0];
        view.textAlignment = NSTextAlignmentRight;
        _countLabel = view;
    }
    return _countLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamedFromMyBundle:@"sl_album_cell_arrow"];
        [view sizeToFit];
        _arrowImageView = view;
    }
    return _arrowImageView;
}

@end
