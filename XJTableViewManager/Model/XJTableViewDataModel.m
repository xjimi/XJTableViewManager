//
//  XJTableViewDataModel.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewDataModel.h"

@implementation XJTableViewDataModel

+ (XJTableViewDataModel *)modelWithSection:(XJTableViewHeaderModel *)headerModel rows:(NSArray *)rows
{
    return [XJTableViewDataModel modelWithSection:headerModel footer:nil rows:rows];
}

+ (XJTableViewDataModel *)modelWithFooter:(XJTableViewFooterModel *)footerModel rows:(NSArray *)rows;
{
    return [XJTableViewDataModel modelWithSection:nil footer:footerModel rows:rows];
}

+ (XJTableViewDataModel *)modelWithSection:(XJTableViewHeaderModel *)headerModel
                                    footer:(XJTableViewFooterModel *)footerModel
                                      rows:(NSArray *)rows
{
    XJTableViewDataModel *dataModel = [[XJTableViewDataModel alloc] init];
    dataModel.section = headerModel;
    dataModel.footer  = footerModel;
    dataModel.rows = rows.mutableCopy;
    return dataModel;
}

@end
