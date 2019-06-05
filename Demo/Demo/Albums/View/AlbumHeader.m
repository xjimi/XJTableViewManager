//
//  AlbumHeader.m
//  Demo
//
//  Created by XJIMI on 2019/6/5.
//  Copyright © 2019 XJIMI. All rights reserved.
//

#import "AlbumHeader.h"

@implementation AlbumHeader

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor blackColor];
    self.backgroundView = bgView;
}

- (void)reloadData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.titleLabel.text = data;
    }
}

@end
