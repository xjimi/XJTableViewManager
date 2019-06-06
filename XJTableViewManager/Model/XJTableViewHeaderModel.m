//
//  XJTableViewHeaderModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewHeaderModel.h"

@implementation XJTableViewHeaderModel

+ (XJTableViewHeaderModel *)modelData
{
    return [XJTableViewHeaderModel modelWithReuseIdentifier:nil headerHeight:0 data:nil delegate:nil];
}

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        headerHeight:(CGFloat)height
                                                data:(id)data
{
    return [XJTableViewHeaderModel modelWithReuseIdentifier:identifier headerHeight:height data:data delegate:nil];
}

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        headerHeight:(CGFloat)height
                                                data:(id)data
                                            delegate:(id)delegate;
{
    XJTableViewHeaderModel *headerModel = [[XJTableViewHeaderModel alloc] init];
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    identifier = identifier ? : @"EmptyHeader";
    headerModel.sectionId = [NSString stringWithFormat:@"%@_%ld", identifier, (long)time];
    headerModel.identifier = identifier;
    headerModel.height = height;
    headerModel.data = data;
    headerModel.delegate = delegate;
    return headerModel;
}

@end
