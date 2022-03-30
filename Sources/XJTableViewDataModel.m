//
//  XJTableViewDataModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewDataModel.h"

@implementation XJTableViewDataModel

+ (XJTableViewDataModel *)modelWithHeader:(nullable XJTableViewHeaderModel *)headerModel
                                     rows:(NSArray *)rows
{
    return [XJTableViewDataModel modelWithHeader:headerModel footer:nil rows:rows];
}

+ (XJTableViewDataModel *)modelWithFooter:(nullable XJTableViewFooterModel *)footerModel
                                     rows:(NSArray *)rows;
{
    return [XJTableViewDataModel modelWithHeader:nil footer:footerModel rows:rows];
}

+ (XJTableViewDataModel *)modelWithHeader:(nullable XJTableViewHeaderModel *)headerModel
                                   footer:(nullable XJTableViewFooterModel *)footerModel
                                     rows:(NSArray *)rows
{
    XJTableViewDataModel *dataModel = [[XJTableViewDataModel alloc] init];
    dataModel.header = headerModel ? : [XJTableViewHeaderModel emptyModel];
    dataModel.footer  = footerModel;
    dataModel.rows = rows.mutableCopy;
    return dataModel;
}

@end
