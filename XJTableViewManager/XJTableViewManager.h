//
//  XJTableViewManager.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJTableViewDataModel.h"
#import "XJTableViewHeaderModel.h"
#import "XJTableViewFooterModel.h"
#import "XJTableViewCellModel.h"
#import "XJTableViewHeader.h"
#import "XJTableViewFooter.h"
#import "XJTableViewCell.h"

@class XJTableViewManager;

@protocol XJTableViewDelegate < NSObject >

@optional
- (NSInteger)xj_tableView:(XJTableViewManager *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)xj_tableView:(XJTableViewManager *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)xj_tableView:(XJTableViewManager *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(XJTableViewManager *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(XJTableViewManager *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (UIView *)xj_tableView:(XJTableViewManager *)tableView viewForHeaderInSection:(NSInteger)section;

- (UITableViewCellEditingStyle)xj_tableView:(XJTableViewManager *)tableView
              editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(XJTableViewManager *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(XJTableViewManager *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(XJTableViewManager *)tableView canMoveRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(XJTableViewManager *)tableView
  moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath
         toIndexPath:(nonnull NSIndexPath *)destinationIndexPath;

@end


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

- (void)addCellForRowBlock:(XJTableViewCellForRowBlock)rowBlock;
- (void)addWillDisplayCellBlock:(XJTableViewWillDisplayCellBlock)cellBlock;
- (void)addDidSelectRowBlock:(XJTableViewDidSelectRowBlock)rowBlock;

- (void)addScrollViewDidScrollBlock:(XJScrollViewDidScrollBlock)scrollViewDidScrollBlock;
- (void)addScrollViewWillBeginDraggingBlock:(XJScrollViewWillBeginDraggingBlock)scrollViewWillBeginDraggingBlock;

- (void)insertData:(NSArray *)data;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
