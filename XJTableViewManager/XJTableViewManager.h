//
//  XJTableViewManager.h
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XJTableViewDataModel.h"
#import "XJTableViewHeaderModel.h"
#import "XJTableViewCellModel.h"
#import "XJTableViewHeader.h"
#import "XJTableViewFooter.h"
#import "XJTableViewCell.h"

@class XJTableViewManager;

@protocol XJTableViewDelegate < NSObject >
@optional

- (NSInteger)xj_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)xj_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)xj_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)xj_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCellEditingStyle)xj_tableView:(UITableView*)tableView
             editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath;

- (void)xj_tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView
  moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath
         toIndexPath:(nonnull NSIndexPath *)destinationIndexPath;

- (UIView *)xj_tableView:(UITableView *)tableView
  viewForHeaderInSection:(NSInteger)section;


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
