//
//  XJTableViewHeaderModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewHeaderModel.h"

@implementation XJTableViewHeaderModel

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier headerHeight:(CGFloat)height data:(id)data
{
    XJTableViewHeaderModel *headerModel = [[XJTableViewHeaderModel alloc] init];
    headerModel.identifier = identifier;
    headerModel.height = height;
    headerModel.data = data;
    return headerModel;
}

@end
