//
//  XJTableViewHeader.h
//  Vidol
//
//  Created by XJIMI on 2015/10/5.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJTableViewHeader;
@protocol XJTableViewHeaderDelegate <NSObject>

@end

@interface XJTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id <XJTableViewHeaderDelegate> delegate;

+ (NSString *)identifier;

+ (UINib *)nib;

- (void)reloadData:(id)data;

@end
