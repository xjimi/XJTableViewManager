//
//  XJTableViewCellModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewCellModel.h"

@interface XJTableViewCellModel ()

@property (nonatomic, copy, readwrite) NSString *identifier;

@end

@implementation XJTableViewCellModel

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(nullable id)data
{
    return [XJTableViewCellModel modelWithReuseIdentifier:identifier cellHeight:height data:data delegate:nil];
}

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(nullable id)data
                                          delegate:(nullable id)delegate
{
    XJTableViewCellModel *cellModel = [[XJTableViewCellModel alloc] init];
    cellModel.identifier = identifier;
    cellModel.height = height;
    cellModel.data = data;
    cellModel.delegate = delegate;
    return cellModel;
}

@end
