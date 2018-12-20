//
//  XJTableViewHeader.m
//  Vidol
//
//  Created by XJIMI on 2015/10/5.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewHeader.h"

@implementation XJTableViewHeader

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

+ (UINib *)nib {
    NSString *identifier = [self identifier];
    return identifier.length ? [UINib nibWithNibName:identifier bundle:nil] : nil;
}

- (void)reloadData:(id)data {
}

@end
