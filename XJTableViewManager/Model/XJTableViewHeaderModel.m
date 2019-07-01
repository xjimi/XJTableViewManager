//
//  XJTableViewHeaderModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewHeaderModel.h"

@interface XJTableViewHeaderModel ()

@property (nonatomic, copy, readwrite) NSString *sectionId;

@property (nonatomic, copy, readwrite) NSString *identifier;

@end

@implementation XJTableViewHeaderModel

+ (XJTableViewHeaderModel *)emptyModel
{
    return [XJTableViewHeaderModel modelWithReuseIdentifier:@"EmptyHeader"
                                               headerHeight:0
                                                       data:nil
                                                   delegate:nil];
}

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        headerHeight:(CGFloat)height
                                                data:(nullable id)data
{
    return [XJTableViewHeaderModel modelWithReuseIdentifier:identifier headerHeight:height data:data delegate:nil];
}

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        headerHeight:(CGFloat)height
                                                data:(nullable id)data
                                            delegate:(nullable id)delegate;
{
    XJTableViewHeaderModel *headerModel = [[XJTableViewHeaderModel alloc] init];
    NSString *key = [XJTableViewHeaderModel referenceKeyForObject:headerModel];
    headerModel.sectionId = [NSString stringWithFormat:@"%@_%@", identifier, key];
    headerModel.identifier = identifier;
    headerModel.height = height;
    headerModel.data = data;
    headerModel.delegate = delegate;
    return headerModel;
}

+ (NSString *)referenceKeyForObject:(id)object {
    return [NSString stringWithFormat:@"%p", object];
}

@end
