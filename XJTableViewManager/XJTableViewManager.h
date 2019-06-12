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

@interface XJTableViewManager : UITableView

@property (nonatomic, weak, nullable) id < XJTableViewDelegate > tableViewDelegate;

@property (nonatomic, strong, nullable) NSMutableArray *data;

+ (instancetype)manager;

+ (instancetype)managerWithStyle:(UITableViewStyle)style;

- (void)disableGroupHeaderHeight;
- (void)disableGroupFooterHeight;

- (void)addCellForRowBlock:(XJTableViewCellForRowBlock)rowBlock;
- (void)addWillDisplayCellBlock:(XJTableViewWillDisplayCellBlock)cellBlock;
- (void)addDidSelectRowBlock:(XJTableViewDidSelectRowBlock)rowBlock;

- (void)addScrollViewDidScrollBlock:(XJScrollViewDidScrollBlock)scrollViewDidScrollBlock;
- (void)addScrollViewWillBeginDraggingBlock:(XJScrollViewWillBeginDraggingBlock)scrollViewWillBeginDraggingBlock;

- (void)appendDataModel:(XJTableViewDataModel *)dataModel;
- (void)appendRowsWithDataModel:(XJTableViewDataModel *)dataModel;
- (void)insertDataModel:(XJTableViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex;

- (nullable XJTableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;
- (nullable XJTableViewHeaderModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
