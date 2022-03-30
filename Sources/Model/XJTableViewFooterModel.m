//
//  XJTableViewFooterModel.m
//  Vidol
//
//  Created by XJIMI on 2017/10/20.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import "XJTableViewFooterModel.h"

@interface XJTableViewFooterModel ()

@property (nonatomic, copy, readwrite) NSString *identifier;

@end

@implementation XJTableViewFooterModel

+ (XJTableViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        footerHeight:(CGFloat)height
                                                data:(nullable id)data
{
    XJTableViewFooterModel *footerModel = [[XJTableViewFooterModel alloc] init];
    footerModel.identifier = identifier;
    footerModel.height = height;
    footerModel.data = data;
    return footerModel;
}

@end
