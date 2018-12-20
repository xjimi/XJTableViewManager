//
//  XJTableViewFooterModel.m
//  Vidol
//
//  Created by XJIMI on 2017/10/20.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import "XJTableViewFooterModel.h"

@implementation XJTableViewFooterModel

+ (XJTableViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier headerHeight:(CGFloat)height data:(id)data
{
    XJTableViewFooterModel *headerModel = [[XJTableViewFooterModel alloc] init];
    headerModel.identifier = identifier;
    headerModel.height = height;
    headerModel.data = data;
    return headerModel;
}

@end
