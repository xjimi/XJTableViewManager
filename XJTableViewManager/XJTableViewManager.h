//
//  XJTableViewManager.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJTableViewDelegate.h"
#import "XJTableViewDataModel.h"
#import "XJTableViewHeaderModel.h"
#import "XJTableViewFooterModel.h"
#import "XJTableViewCellModel.h"
#import "XJTableViewHeader.h"
#import "XJTableViewFooter.h"
#import "XJTableViewCell.h"


typedef void (^XJTableViewCellForRowBlock) (XJTableViewCellModel *cellModel, XJTableViewCell *cell, NSIndexPath *indexPath);

typedef void (^XJTableViewDidSelectRowBlock) (XJTableViewCellModel *cellModel, NSIndexPath *indexPath);

typedef void (^XJTableViewWillDisplayCellBlock) (XJTableViewCellModel *cellModel, XJTableViewCell *cell, NSIndexPath *indexPath);

typedef void (^XJScrollViewDidScrollBlock) (UIScrollView *scrollView);

typedef void (^XJScrollViewWillBeginDraggingBlock) (UIScrollView *scrollView);

@interface XJTableViewManager : UITableView

@property (nonatomic, weak) id < XJTableViewDelegate > tableViewDelegate;

@property (nonatomic, strong) NSMutableArray *data;

+ (instancetype)manager;

+ (instancetype)managerWithStyle:(UITableViewStyle)style;

- (void)disableGroupHeaderHeight;
- (void)disableGroupFooterHeight;

- (void)addCellForRowBlock:(XJTableViewCellForRowBlock)rowBlock;
- (void)addWillDisplayCellBlock:(XJTableViewWillDisplayCellBlock)cellBlock;
- (void)addDidSelectRowBlock:(XJTableViewDidSelectRowBlock)rowBlock;

- (void)addScrollViewDidScrollBlock:(XJScrollViewDidScrollBlock)scrollViewDidScrollBlock;
- (void)addScrollViewWillBeginDraggingBlock:(XJScrollViewWillBeginDraggingBlock)scrollViewWillBeginDraggingBlock;

- (void)insertDataModel:(XJTableViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex;

- (void)appendDataModel:(XJTableViewDataModel *)dataModel;

- (void)appendRowsWithDataModel:(XJTableViewDataModel *)dataModel;

- (XJTableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;

- (XJTableViewHeaderModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath;

@end
