//
//  AlbumCell.h
//  Demo
//
//  Created by XJIMI on 2019/6/5.
//  Copyright © 2019 XJIMI. All rights reserved.
//

#import <XJTableViewManager/XJTableViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCell : XJTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

NS_ASSUME_NONNULL_END
