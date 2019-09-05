//
//  XJTableViewManager.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XJTableViewDelegate.h"
#import "XJTableViewDataModel.h"
#import "XJTableViewHeaderModel.h"
#import "XJTableViewFooterModel.h"
#import "XJTableViewCellModel.h"
#import "XJTableViewHeader.h"
#import "XJTableViewFooter.h"
#import "XJTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^XJTableViewCellForRowBlock) (XJTableViewCellModel *cellModel, XJTableViewCell *cell, NSIndexPath *indexPath);

typedef void (^XJTableViewDidSelectRowBlock) (XJTableViewCellModel *cellModel, NSIndexPath *indexPath);

typedef void (^XJTableViewWillDisplayCellBlock) (XJTableViewCellModel *cellModel, XJTableViewCell *cell, NSIndexPath *indexPath);

typedef void (^XJScrollViewDidScrollBlock) (UIScrollView *scrollView);

typedef void (^XJScrollViewWillBeginDraggingBlock) (UIScrollView *scrollView);

typedef void (^XJScrollViewDidEndDraggingBlock) (UIScrollView *scrollView, BOOL decelerate);

typedef void (^XJScrollViewDidEndDeceleratingBlock) (UIScrollView *scrollView);

@interface XJTableViewManager : UITableView

@property (nonatomic, weak, nullable) id < XJTableViewDelegate > tableViewDelegate;

+ (instancetype)manager;

+ (instancetype)managerWithStyle:(UITableViewStyle)style;

/** Set DataModel **/
- (void)refreshDataModel:(XJTableViewDataModel *)dataModel;
- (void)refreshDataModels:(NSArray <XJTableViewDataModel *> *)dataModels;

- (void)appendDataModel:(XJTableViewDataModel *)dataModel;
- (void)appendDataModels:(NSArray <XJTableViewDataModel *> *)dataModels;
- (void)appendRowsWithDataModel:(XJTableViewDataModel *)dataModel;

- (void)insertDataModel:(XJTableViewDataModel *)dataModel atSectionIndex:(NSInteger)sectionIndex;
- (void)insertDataModels:(NSArray <XJTableViewDataModel *> *)dataModel atSectionIndex:(NSInteger)sectionIndex;

- (void)removeDataModel:(XJTableViewDataModel *)dataModel;

/** Get DataModel **/
- (NSArray *)allDataModels;
- (nullable XJTableViewDataModel *)dataModelAtSectionIndex:(NSInteger)sectionIndex;
- (nullable XJTableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;
- (nullable XJTableViewHeaderModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath;

/** 將 UITableViewStyleGrouped 的上下間距設為 0 **/
- (void)disableGroupHeaderHeight;
- (void)disableGroupFooterHeight;

/** 使用 Block 監聽 TableView 事件 **/
- (void)addCellForRowBlock:(XJTableViewCellForRowBlock)rowBlock;
- (void)addWillDisplayCellBlock:(XJTableViewWillDisplayCellBlock)cellBlock;
- (void)addDidSelectRowBlock:(XJTableViewDidSelectRowBlock)rowBlock;

/** 使用 Block 監聽 ScrollView 事件 **/
- (void)addScrollViewDidScrollBlock:(XJScrollViewDidScrollBlock)scrollViewDidScrollBlock;
- (void)addScrollViewWillBeginDraggingBlock:(XJScrollViewWillBeginDraggingBlock)scrollViewWillBeginDraggingBlock;
- (void)addScrollViewDidEndDraggingBlock:(XJScrollViewDidEndDraggingBlock)scrollViewDidEndDraggingBlock;
- (void)addScrollViewDidEndDeceleratingBlock:(XJScrollViewDidEndDeceleratingBlock)scrollViewDidEndDeceleratingBlock;

@end

NS_ASSUME_NONNULL_END
