//
//  XJTableViewFooter.h
//  Vidol
//
//  Created by XJIMI on 2017/10/20.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class XJTableViewFooter;
@protocol XJTableViewFooterDelegate <NSObject>

@end

@interface XJTableViewFooter : UITableViewHeaderFooterView

@property (nonatomic, weak) id <XJTableViewFooterDelegate> delegate;

+ (NSString *)identifier;

+ (UINib *)nib;

- (void)reloadData:(id)data;

@end
