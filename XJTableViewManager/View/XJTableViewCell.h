//
//  XJTableViewCell.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJTableViewCell;

@protocol XJTableViewCellDelegate <NSObject>

@optional
- (void)xj_tableViewCell:(UITableViewCell *)tableViewCell
           didSelectItem:(id)item
             atIndexPath:(NSIndexPath *)indexPath;

- (void)xj_refreshTableViewCell:(UITableViewCell *)tableViewCell;

@end

@interface XJTableViewCell : UITableViewCell

@property (nonatomic, weak) id <XJTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;


+ (NSString *)identifier;

+ (UINib *)nib;

- (void)reloadData:(id)data;

- (void)willDisplay;

@end
