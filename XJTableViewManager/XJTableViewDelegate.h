//
//  XJTableViewDelegate.h
//  Pods
//
//  Created by XJIMI on 2018/12/20.
//

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
