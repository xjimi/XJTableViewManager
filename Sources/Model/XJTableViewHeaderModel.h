//
//  XJTableViewHeaderModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJTableViewHeaderModel : NSObject

@property (nonatomic, copy, readonly) NSString *sectionId;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, weak, nullable) id delegate;

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        headerHeight:(CGFloat)height
                                                data:(nullable id)data;

+ (XJTableViewHeaderModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        headerHeight:(CGFloat)height
                                                data:(nullable id)data
                                            delegate:(nullable id)delegate;

+ (XJTableViewHeaderModel *)emptyModel;

@end

NS_ASSUME_NONNULL_END
