//
//  XJTableViewDataModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJTableViewHeaderModel.h"
#import "XJTableViewFooterModel.h"
#import "XJTableViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJTableViewDataModel : NSObject

@property (nonatomic, strong, nullable) XJTableViewHeaderModel *section;
@property (nonatomic, strong, nullable) XJTableViewFooterModel *footer;
@property (nonatomic, strong) NSMutableArray *rows;

+ (XJTableViewDataModel *)modelWithSection:(nullable XJTableViewHeaderModel *)headerModel
                                      rows:(NSArray *)rows;

+ (XJTableViewDataModel *)modelWithFooter:(nullable XJTableViewFooterModel *)footerModel
                                     rows:(NSArray *)rows;

+ (XJTableViewDataModel *)modelWithSection:(nullable XJTableViewHeaderModel *)headerModel
                                    footer:(nullable XJTableViewFooterModel *)footerModel
                                      rows:(NSArray *)rows;

@end

NS_ASSUME_NONNULL_END
