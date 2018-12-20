//
//  XJTableViewCellModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewCellModel.h"

@implementation XJTableViewCellModel

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(id)data
{
    return [XJTableViewCellModel modelWithReuseIdentifier:identifier cellHeight:height data:data delegate:nil];
}

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(id)data
                                          delegate:(id)delegate
{
    XJTableViewCellModel *cellModel = [[XJTableViewCellModel alloc] init];
    cellModel.identifier = identifier;
    cellModel.height = height;
    cellModel.data = data;
    cellModel.delegate = delegate;
    return cellModel;
}

@end
