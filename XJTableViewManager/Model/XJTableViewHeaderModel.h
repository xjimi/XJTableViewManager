//
//  XJTableViewHeaderModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XJTableViewHeaderModel : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) id data;

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier headerHeight:(CGFloat)height data:(id)data;

@end
