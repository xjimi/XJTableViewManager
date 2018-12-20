//
//  XJTableViewFooter.m
//  Vidol
//
//  Created by XJIMI on 2017/10/20.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import "XJTableViewFooter.h"

@implementation XJTableViewFooter

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
