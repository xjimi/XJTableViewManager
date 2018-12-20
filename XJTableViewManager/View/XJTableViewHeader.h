//
//  XJTableViewHeader.h
//  Vidol
//
//  Created by XJIMI on 2015/10/5.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJTableViewHeader : UITableViewHeaderFooterView

+ (NSString *)identifier;

+ (UINib *)nib;

- (void)reloadData:(id)data;

@end
