//
//  XJTableViewCellModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJTableViewCellModel : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong, nullable) id data;
@property (nonatomic, weak, nullable) id delegate;
@property (nonatomic, assign, nullable) Class registerClass;
@property (nonatomic, copy, nullable) NSString *registerNibName;

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(nullable id)data;

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(nullable id)data
                                          delegate:(nullable id)delegate;
@end

NS_ASSUME_NONNULL_END
