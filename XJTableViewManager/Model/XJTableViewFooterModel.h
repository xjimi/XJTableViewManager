//
//  XJTableViewFooterModel.h
//  Vidol
//
//  Created by XJIMI on 2017/10/20.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJTableViewFooterModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) id data;

+ (XJTableViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier headerHeight:(CGFloat)height data:(id)data;

@end
