//
//  XJTableViewDelegate.h
//  Pods
//
//  Created by XJIMI on 2018/12/20.
//

NS_ASSUME_NONNULL_BEGIN

@protocol XJTableViewDelegate < NSObject >

@optional

- (NSInteger)xj_tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section;

- (CGFloat)xj_tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)xj_tableView:(UITableView *)tableView
            cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

- (nullable UIView *)xj_tableView:(UITableView *)tableView
           viewForHeaderInSection:(NSInteger)section;

- (nullable UIView *)xj_tableView:(UITableView *)tableView
           viewForFooterInSection:(NSInteger)section;

- (UITableViewCellEditingStyle)xj_tableView:(UITableView *)tableView
              editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath;

- (BOOL)xj_tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)xj_tableView:(UITableView *)tableView
  moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
         toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

NS_ASSUME_NONNULL_END
