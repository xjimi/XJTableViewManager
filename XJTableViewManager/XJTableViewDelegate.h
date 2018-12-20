//
//  XJTableViewDelegate.h
//  Pods
//
//  Created by XJIMI on 2018/12/20.
//

@protocol XJTableViewDelegate < NSObject >

@optional
- (NSInteger)xj_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)xj_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)xj_tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (UIView *)xj_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (UITableViewCellEditingStyle)xj_tableView:(UITableView *)tableView
              editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(UITableView *)tableView canMoveRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView
  moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath
         toIndexPath:(nonnull NSIndexPath *)destinationIndexPath;

@end
