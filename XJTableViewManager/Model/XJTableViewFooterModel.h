//
//  XJTableViewFooterModel.h
//  Vidol
//
//  Created by XJIMI on 2017/10/20.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJTableViewFooterModel : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong, nullable) id data;

+ (XJTableViewFooterModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        footerHeight:(CGFloat)height
                                                data:(nullable id)data;
@end

NS_ASSUME_NONNULL_END
