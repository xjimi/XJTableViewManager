//
//  AlbumFooter.m
//  Demo
//
//  Created by XJIMI on 2020/1/4.
//  Copyright © 2020 XJIMI. All rights reserved.
//

#import "AlbumFooter.h"

@implementation AlbumFooter

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
