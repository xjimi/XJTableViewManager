//
//  XJTableViewManager.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewManager.h"

@interface XJTableViewManager () < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) NSMutableArray *registeredCells;
@property (nonatomic, copy)   XJTableViewCellForRowBlock cellForRowBlock;
@property (nonatomic, copy)   XJTableViewWillDisplayCellBlock willDisplayCellBlock;
@property (nonatomic, copy)   XJTableViewDidSelectRowBlock didSelectRowBlock;
@property (nonatomic, copy)   XJScrollViewDidScrollBlock scrollViewDidScrollBlock;
@property (nonatomic, copy)   XJScrollViewWillBeginDraggingBlock scrollViewWillBeginDraggingBlock;
@property (nonatomic, assign) CGFloat defaultGroupHeaderHeight;
@property (nonatomic, assign) CGFloat defaultGroupFooterHeight;

@end

@implementation XJTableViewManager

+ (instancetype)manager {
    return [self managerWithStyle:UITableViewStylePlain];
}

+ (instancetype)managerWithStyle:(UITableViewStyle)style {
    return [[self alloc] initWithFrame:CGRectZero style:style];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delaysContentTouches = YES;
    self.alwaysBounceVertical = YES;

    self.estimatedRowHeight = 0.0f;
    self.estimatedSectionHeaderHeight = 0.0f;
    self.estimatedSectionFooterHeight = 0.0f;
    self.backgroundColor = [UIColor clearColor];
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    if (self.style == UITableViewStylePlain) {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.data = [NSMutableArray array];
    self.registeredCells = [NSMutableArray array];
}

- (void)disableGroupHeaderHeight
{
    if (self.style == UITableViewStyleGrouped) {
        self.defaultGroupHeaderHeight = CGFLOAT_MIN;
    }
}

- (void)disableGroupFooterHeight
{
    if (self.style == UITableViewStyleGrouped) {
        self.defaultGroupFooterHeight = CGFLOAT_MIN;
    }
}

- (void)addDidSelectRowBlock:(XJTableViewDidSelectRowBlock)rowBlock {
    self.didSelectRowBlock = rowBlock;
}

- (void)addCellForRowBlock:(XJTableViewCellForRowBlock)rowBlock {
    self.cellForRowBlock = rowBlock;
}

- (void)addWillDisplayCellBlock:(XJTableViewWillDisplayCellBlock)cellBlock {
    self.willDisplayCellBlock = cellBlock;
}

- (void)addScrollViewDidScrollBlock:(XJScrollViewDidScrollBlock)scrollViewDidScrollBlock {
    self.scrollViewDidScrollBlock = scrollViewDidScrollBlock;
}

- (void)addScrollViewWillBeginDraggingBlock:(XJScrollViewWillBeginDraggingBlock)scrollViewWillBeginDraggingBlock {
    self.scrollViewWillBeginDraggingBlock = scrollViewWillBeginDraggingBlock;
}

- (void)setData:(nullable NSMutableArray *)data
{
    if (!data) data = [NSMutableArray array];
    [self registerCellWithData:data];
    _data = data;
    [self reloadData];
}

- (void)appendRowsWithDataModel:(XJTableViewDataModel *)dataModel
{
    if (!dataModel.section && !dataModel.rows.count) return;

    if (!_data)
    {
        self.data = @[dataModel].mutableCopy;
        return;
    }

    [self registerCellWithData:@[dataModel]];

    NSInteger sessionIndex = self.data.count - 1;
    for (XJTableViewDataModel *data in self.data)
    {
        if ([dataModel.section.sectionId isEqualToString:data.section.sectionId]) {
            sessionIndex = [self.data indexOfObject:data];
            break;
        }
    }

    XJTableViewDataModel *curDataModel = [self.data objectAtIndex:sessionIndex];
    NSInteger numberOfRows = curDataModel.rows.count;
    NSInteger totalRowsCount = curDataModel.rows.count + dataModel.rows.count;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = numberOfRows; i < totalRowsCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sessionIndex]];
    }
    [curDataModel.rows addObjectsFromArray:dataModel.rows];

    [UIView performWithoutAnimation:^{
        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)appendDataModel:(XJTableViewDataModel *)dataModel {
    [self insertDataModel:dataModel atSectionIndex:self.data.count];
}

- (void)insertDataModel:(XJTableViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex
{
    if (!dataModel.section && !dataModel.rows.count) return;

    if (!self.data) {
        self.data = @[dataModel].mutableCopy;
        return;
    }

    [self registerCellWithData:@[dataModel]];

    if (sectionIndex > self.data.count) {
        sectionIndex = self.data.count;
    }

    [self.data insertObject:dataModel atIndex:sectionIndex];

    [UIView performWithoutAnimation:^{
        [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)registerCellWithData:(NSArray *)data
{
    for (XJTableViewDataModel *dataModel in data)
    {
        NSString *headerReusableId = dataModel.section.identifier;
        if (dataModel.section && headerReusableId.length)
        {
            if (![self.registeredCells containsObject:headerReusableId])
            {
                [self.registeredCells addObject:headerReusableId];

                Class class = NSClassFromString(headerReusableId);
                NSBundle *bundle = [NSBundle bundleForClass:class];
                if([bundle pathForResource:headerReusableId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:headerReusableId bundle:bundle];
                    [self registerNib:nib forHeaderFooterViewReuseIdentifier:headerReusableId];
                }
                else
                {
                    [self registerClass:class forHeaderFooterViewReuseIdentifier:headerReusableId];
                }
            }
        }

        NSString *footerReusableId = dataModel.footer.identifier;
        if (dataModel.footer && footerReusableId.length)
        {

            if (![self.registeredCells containsObject:footerReusableId])
            {
                [self.registeredCells addObject:footerReusableId];

                Class class = NSClassFromString(footerReusableId);
                NSBundle *bundle = [NSBundle bundleForClass:class];
                if([bundle pathForResource:footerReusableId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:footerReusableId bundle:bundle];
                    [self registerNib:nib forHeaderFooterViewReuseIdentifier:footerReusableId];
                }
                else
                {
                    [self registerClass:class forHeaderFooterViewReuseIdentifier:footerReusableId];
                }
            }
        }

        if (dataModel.rows)
        {
            for (XJTableViewCellModel *cellModel in dataModel.rows)
            {
                NSString *cellId = cellModel.identifier;
                if (cellId.length)
                {
                    if ([self.registeredCells containsObject:cellId]) continue;
                    [self.registeredCells addObject:cellId];

                    NSString *nibName = cellModel.registerNibName ? : cellId;
                    Class class = NSClassFromString(nibName);
                    NSBundle *bundle = [NSBundle bundleForClass:class];
                    if([bundle pathForResource:nibName ofType:@"nib"])
                    {
                        UINib *nib = [UINib nibWithNibName:nibName bundle:bundle];
                        [self registerNib:nib forCellReuseIdentifier:cellId];
                    }
                    else
                    {
                        Class registerClass = cellModel.registerClass ? : NSClassFromString(cellId);
                        [self registerClass:registerClass forCellReuseIdentifier:cellId];
                    }
                }
            }
        }
    }
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = self.data[section];
    return dataModel.section.height ? : self.defaultGroupHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = self.data[section];
    return dataModel.footer.height ? : self.defaultGroupFooterHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:viewForHeaderInSection:)]) {
        return [self.tableViewDelegate xj_tableView:self viewForHeaderInSection:section];
    }

    XJTableViewDataModel *dataModel = self.data[section];
    XJTableViewHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:dataModel.section.identifier];
    headerView.delegate = dataModel.section.delegate;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    [headerView reloadData:dataModel.section.data];
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:viewForFooterInSection:)]) {
        return [self.tableViewDelegate xj_tableView:self viewForFooterInSection:section];
    }

    XJTableViewDataModel *dataModel = self.data[section];
    XJTableViewFooter *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:dataModel.footer.identifier];
    [footerView reloadData:dataModel.footer.data];
    return footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = self.data[section];
    if ([dataModel.section.data isKindOfClass:[NSString class]] &&
        !dataModel.section.identifier)
    {
        return dataModel.section.data;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = self.data[section];
    if ([dataModel.footer.data isKindOfClass:[NSString class]] &&
        !dataModel.footer.identifier)
    {
        return dataModel.footer.data;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = self.data[section];
    if (![self.tableViewDelegate respondsToSelector:@selector(xj_tableView:numberOfRowsInSection:)]) {
        return dataModel.rows.count;
    } else {
        return [self.tableViewDelegate xj_tableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:heightForRowAtIndexPath:)]) {
        CGFloat height = [self.tableViewDelegate xj_tableView:tableView heightForRowAtIndexPath:indexPath];
        if (height != 0) return height;
    }

    XJTableViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    XJTableViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    return cellModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:cellForRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    XJTableViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    XJTableViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    XJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.identifier forIndexPath:indexPath];
    [cell layoutIfNeeded];
    cell.delegate = cellModel.delegate;
    cell.indexPath = indexPath;
    [cell reloadData:cellModel.data];
    if (self.cellForRowBlock) self.cellForRowBlock(cellModel, cell, indexPath);
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XJTableViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    if (indexPath.row >= dataModel.rows.count) return;
    XJTableViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    if (self.willDisplayCellBlock) self.willDisplayCellBlock(cellModel, (XJTableViewCell *)cell, indexPath);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:didSelectRowAtIndexPath:)]) {
        [self.tableViewDelegate xj_tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }

    if (self.didSelectRowBlock)
    {
        XJTableViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
        XJTableViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
        self.didSelectRowBlock(cellModel, indexPath);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:canEditRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }

    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:didEndEditingRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:canMoveRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:moveRowAtIndexPath:toIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock (scrollView);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollViewWillBeginDraggingBlock) {
        self.scrollViewWillBeginDraggingBlock (scrollView);
    }
}

#pragma mark

- (nullable XJTableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.data.count) {
        return nil;
    }
    XJTableViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    if (indexPath.row >= dataModel.rows.count) {
        return nil;
    }
    XJTableViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    return cellModel;
}

- (nullable XJTableViewHeaderModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.data.count) {
        return nil;
    }
    XJTableViewDataModel *dataModel = [self.data objectAtIndex:indexPath.section];
    return dataModel.section;
}

- (nullable NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath
{
    XJTableViewHeaderModel *headerModel = [self headerModelAtIndexPath:indexPath];
    return headerModel.sectionId;
}

@end
