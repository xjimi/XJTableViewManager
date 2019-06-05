//
//  AlbumCell.m
//  Demo
//
//  Created by XJIMI on 2019/6/5.
//  Copyright © 2019 XJIMI. All rights reserved.
//

#import "AlbumCell.h"
#import "AlbumModel.h"

@implementation AlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)reloadData:(id)data
{
    if ([data isKindOfClass:[AlbumModel class]])
    {
        AlbumModel *album = (AlbumModel *)data;
        self.coverImageView.image = [UIImage imageNamed:album.imageName];
        self.titleLabel.text = album.albumName;
        self.subtitleLabel.text = album.artistName;
    }
}

@end
