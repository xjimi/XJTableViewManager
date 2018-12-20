//
//  XJTableViewCellModel.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XJTableViewCellModel : NSObject

@property (nonatomic, copy)   NSString *identifier;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) id data;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) Class registerClass;
@property (nonatomic, copy)   NSString *registerNibName;

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(id)data;

+ (XJTableViewCellModel *)modelWithReuseIdentifier:(NSString *)identifier
                                        cellHeight:(CGFloat)height
                                              data:(id)data
                                          delegate:(id)delegate;

@end
