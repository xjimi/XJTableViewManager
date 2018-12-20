//
//  XJTableViewCell.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewCell.h"

@implementation XJTableViewCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (UINib *)nib {
    NSString *identifier = [self identifier];
    return identifier.length ? [UINib nibWithNibName:identifier bundle:nil] : nil; 
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)reloadData:(id)data {
}

@end
