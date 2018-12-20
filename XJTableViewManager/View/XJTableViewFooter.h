//
//  XJTableViewFooter.h
//  Vidol
//
//  Created by XJIMI on 2017/10/20.
//  Copyright © 2017年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJTableViewFooter : UITableViewHeaderFooterView

+ (NSString *)identifier;

+ (UINib *)nib;

- (void)reloadData:(id)data;

@end
