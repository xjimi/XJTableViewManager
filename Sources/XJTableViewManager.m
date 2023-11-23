//
//  XJTableViewManager.m
//  Vidol
//
//  Created by XJIMI on 2015/10/4.
//  Copyright © 2015年 XJIMI. All rights reserved.
//

#import "XJTableViewManager.h"

@interface XJTableViewManager () < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) NSMutableArray <XJTableViewDataModel *> *dataModels;
@property (nonatomic, strong) NSMutableArray *registeredCells;
@property (nonatomic, copy)   XJTableViewCellForRowBlock cellForRowBlock;
@property (nonatomic, copy)   XJTableViewWillDisplayCellBlock willDisplayCellBlock;
@property (nonatomic, copy)   XJTableViewDidEndDisplayCellBlock didEndDisplayCellBlock;
@property (nonatomic, copy)   XJTableViewDidSelectRowBlock didSelectRowBlock;
@property (nonatomic, copy)   XJScrollViewDidScrollBlock scrollViewDidScrollBlock;
@property (nonatomic, copy)   XJScrollViewWillBeginDraggingBlock scrollViewWillBeginDraggingBlock;
@property (nonatomic, copy)   XJScrollViewDidEndDraggingBlock scrollViewDidEndDraggingBlock;
@property (nonatomic, copy)   XJScrollViewDidEndDeceleratingBlock scrollViewDidEndDeceleratingBlock;
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

    _dataModels = [NSMutableArray array];
    _registeredCells = [NSMutableArray array];
}

#pragma mark - TableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:numberOfRowsInSection:)]) {
        NSInteger rowsCount = [self.tableViewDelegate xj_tableView:self numberOfRowsInSection:section];
        if (rowsCount) return rowsCount;
    }

    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    return dataModel.rows.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    if ([dataModel.header.data isKindOfClass:[NSString class]] && !dataModel.header.identifier) {
        return dataModel.header.data;
    }
    return nil;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    if ([dataModel.footer.data isKindOfClass:[NSString class]] && !dataModel.footer.identifier) {
        return dataModel.footer.data;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:cellForRowAtIndexPath:)]) {
        UITableViewCell *cell = [self.tableViewDelegate xj_tableView:tableView cellForRowAtIndexPath:indexPath];
        if (cell) return cell;
    }

    XJTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    XJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.identifier forIndexPath:indexPath];
    /// dequeueReusableCellWithIdentifier 第 2 次 init 時 cell 的 frame 會重置 (ex:  frame.width = 320)

    cell.delegate = cellModel.delegate;
    cell.indexPath = indexPath;
    [cell reloadData:cellModel.data];
    if (self.cellForRowBlock) self.cellForRowBlock(cellModel, cell, indexPath);
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:canEditRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:moveRowAtIndexPath:toIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.willDisplayCellBlock)
    {
        XJTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
        self.willDisplayCellBlock(cellModel, (XJTableViewCell *)cell, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didEndDisplayCellBlock)
    {
        XJTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
        self.didEndDisplayCellBlock(cellModel, (XJTableViewCell *)cell, indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    return dataModel.header.height ? : self.defaultGroupHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    return dataModel.footer.height ? : self.defaultGroupFooterHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:viewForHeaderInSection:)]) {
        UIView *view = [self.tableViewDelegate xj_tableView:self viewForHeaderInSection:section];
        if (view) return view;
    }

    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    XJTableViewHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:dataModel.header.identifier];
    headerView.delegate = dataModel.header.delegate;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    [headerView reloadData:dataModel.header.data];
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:viewForFooterInSection:)]) {
        UIView *view = [self.tableViewDelegate xj_tableView:self viewForFooterInSection:section];
        if (view) return view;
    }

    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:section];
    XJTableViewFooter *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:dataModel.footer.identifier];
    [footerView reloadData:dataModel.footer.data];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:heightForRowAtIndexPath:)]) {
        CGFloat height = [self.tableViewDelegate xj_tableView:tableView heightForRowAtIndexPath:indexPath];
        if (height) return height;
    }

    XJTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.height;
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
        XJTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
        self.didSelectRowBlock(cellModel, indexPath);
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }

    return UITableViewCellEditingStyleNone;
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

#pragma mark - Set dataModel

- (void)setDataModels:(NSMutableArray <XJTableViewDataModel *> *)dataModels
{
    [self registerCellWithData:dataModels];
    _dataModels = dataModels;
    [self reloadData];
}

- (void)refreshDataModel:(XJTableViewDataModel *)dataModel
{
    if (!dataModel) return;
    [self refreshDataModels:@[dataModel]];
}

- (void)refreshDataModels:(NSArray <XJTableViewDataModel *> *)dataModels
{
    if (!dataModels || !dataModels.count) return;
    self.dataModels = dataModels.mutableCopy;
}

- (void)appendDataModel:(XJTableViewDataModel *)dataModel {
    [self insertDataModel:dataModel atSectionIndex:self.dataModels.count];
}

- (void)appendDataModels:(NSArray <XJTableViewDataModel *> *)dataModels
{
    for (XJTableViewDataModel *dataModel in dataModels) {
        [self appendDataModel:dataModel];
    }
}

- (void)appendRowsWithDataModel:(XJTableViewDataModel *)dataModel
{
    if (!dataModel.header && !dataModel.rows.count) return;

    if (!self.dataModels)
    {
        [self refreshDataModel:dataModel];
        return;
    }

    [self registerCellWithData:@[dataModel]];

    NSInteger sessionIndex = self.dataModels.count - 1;
    for (XJTableViewDataModel *data in self.dataModels)
    {
        if ([dataModel.header.sectionId isEqualToString:data.header.sectionId]) {
            sessionIndex = [self.dataModels indexOfObject:data];
            break;
        }
    }

    XJTableViewDataModel *curDataModel = [self dataModelAtSectionIndex:sessionIndex];
    NSInteger numberOfRows = curDataModel.rows.count;
    NSInteger totalRowsCount = curDataModel.rows.count + dataModel.rows.count;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger i = numberOfRows; i < totalRowsCount; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sessionIndex]];
    }
    [curDataModel.rows addObjectsFromArray:dataModel.rows];
    [self reloadData];
}

- (void)insertDataModel:(XJTableViewDataModel *)dataModel
         atSectionIndex:(NSInteger)sectionIndex
{
    if (!dataModel.header && !dataModel.rows.count) return;

    if (!self.dataModels) {
        [self refreshDataModel:dataModel];
        return;
    }

    [self registerCellWithData:@[dataModel]];

    if (sectionIndex > self.dataModels.count) {
        sectionIndex = self.dataModels.count;
    }

    [self.dataModels insertObject:dataModel atIndex:sectionIndex];
    [self reloadData];
}

- (void)insertDataModels:(NSArray <XJTableViewDataModel *> *)dataModels
          atSectionIndex:(NSInteger)sectionIndex
{
    NSArray *reverseDataModels = [[dataModels reverseObjectEnumerator] allObjects];
    for (XJTableViewDataModel *dataModel in reverseDataModels) {
        [self insertDataModel:dataModel atSectionIndex:sectionIndex];
    }
}

- (void)removeDataModel:(XJTableViewDataModel *)dataModel {
    if ([self.dataModels containsObject:dataModel]) {
        [self.dataModels removeObject:dataModel];
        [self reloadData];
    }
}

#pragma mark - Get dataModel

- (NSArray *)allDataModels {
    return self.dataModels;
}

- (nullable XJTableViewDataModel *)dataModelAtSectionIndex:(NSInteger)sectionIndex
{
    if (sectionIndex < 0 || sectionIndex >= self.dataModels.count) {
        return nil;
    }
    XJTableViewDataModel *dataModel = [self.dataModels objectAtIndex:sectionIndex];
    return dataModel;
}

- (nullable XJTableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath
{
    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    if (indexPath.row < 0 || indexPath.row >= dataModel.rows.count) {
        return nil;
    }
    XJTableViewCellModel *cellModel = [dataModel.rows objectAtIndex:indexPath.row];
    return cellModel;
}

- (nullable XJTableViewHeaderModel *)headerModelAtIndexPath:(NSIndexPath *)indexPath
{
    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    return dataModel.header;
}

- (nullable XJTableViewHeaderModel *)footerModelAtIndexPath:(NSIndexPath *)indexPath
{
    XJTableViewDataModel *dataModel = [self dataModelAtSectionIndex:indexPath.section];
    return dataModel.footer;
}

- (nullable NSString *)sessionIdAtIndexPath:(NSIndexPath *)indexPath
{
    XJTableViewHeaderModel *headerModel = [self headerModelAtIndexPath:indexPath];
    return headerModel.sectionId;
}

#pragma mark - Update cell

- (void)updateCellModelAtIndexPath:(NSIndexPath *)indexPath
              updateCellModelBlock:(XJTableViewCellModel * _Nullable (^)(XJTableViewCellModel * _Nullable cellModel))cellModelBlock
{
    if (!cellModelBlock) return;

    XJTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    XJTableViewCellModel *returnCellModel = cellModelBlock(cellModel);
    if (returnCellModel) {
        [self reloadData];
    }
}

- (void)updateCellModelsAtIndexPaths:(NSArray *)indexPaths
               updateCellModelsBlock:(NSArray * _Nullable (^)(NSArray * _Nullable cellModels))cellModelsBlock
{
    if (!cellModelsBlock) return;

    NSMutableArray *cellModels = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths)
    {
        XJTableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
        [cellModels addObject:cellModel];
    }

    NSArray *returnCellModels = cellModelsBlock(cellModels);
    if (returnCellModels && indexPaths) {
        [self reloadData];
    }
}

- (void)updateHeaderModelAtIndexPath:(NSIndexPath *)indexPath
              updateHeaderModelBlock:(XJTableViewHeaderModel * _Nullable (^)(XJTableViewHeaderModel * _Nullable headerModel))headerModelBlock
{
    if (!headerModelBlock) return;

    XJTableViewHeaderModel *headerModel = [self headerModelAtIndexPath:indexPath];
    XJTableViewHeaderModel *returnHeaderModel = headerModelBlock(headerModel);
    if (returnHeaderModel) {
        [self reloadData];
    }
}

- (void)updateFooterModelAtIndexPath:(NSIndexPath *)indexPath
              updateFooterModelBlock:(XJTableViewFooterModel * _Nullable (^)(XJTableViewFooterModel * _Nullable footerModel))footerModelBlock
{
    if (!footerModelBlock) return;

    XJTableViewFooterModel *footerModel = [self footerModelAtIndexPath:indexPath];
    XJTableViewFooterModel *returnFooterModel = footerModelBlock(footerModel);
    if (returnFooterModel) {
        [self reloadData];
    }
}

#pragma mark - Register cell

- (void)registerCellWithData:(NSArray *)data
{
    for (XJTableViewDataModel *dataModel in data)
    {
        NSString *headerReusableId = dataModel.header.identifier;
        if (dataModel.header && headerReusableId.length)
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

#pragma mark - Public function

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

#pragma mark - ScrollView block

- (void)addDidSelectRowBlock:(XJTableViewDidSelectRowBlock)rowBlock {
    self.didSelectRowBlock = rowBlock;
}

- (void)addCellForRowBlock:(XJTableViewCellForRowBlock)rowBlock {
    self.cellForRowBlock = rowBlock;
}

- (void)addWillDisplayCellBlock:(XJTableViewWillDisplayCellBlock)cellBlock {
    self.willDisplayCellBlock = cellBlock;
}

- (void)addDidEndDisplayCellBlock:(XJTableViewDidEndDisplayCellBlock)cellBlock {
    self.didEndDisplayCellBlock = cellBlock;
}

- (void)addScrollViewDidScrollBlock:(XJScrollViewDidScrollBlock)scrollViewDidScrollBlock {
    self.scrollViewDidScrollBlock = scrollViewDidScrollBlock;
}

- (void)addScrollViewWillBeginDraggingBlock:(XJScrollViewWillBeginDraggingBlock)scrollViewWillBeginDraggingBlock {
    self.scrollViewWillBeginDraggingBlock = scrollViewWillBeginDraggingBlock;
}

- (void)addScrollViewDidEndDraggingBlock:(XJScrollViewDidEndDraggingBlock)scrollViewDidEndDraggingBlock {
    self.scrollViewDidEndDraggingBlock = scrollViewDidEndDraggingBlock;
}

- (void)addScrollViewDidEndDeceleratingBlock:(XJScrollViewDidEndDeceleratingBlock)scrollViewDidEndDeceleratingBlock {
    self.scrollViewDidEndDeceleratingBlock = scrollViewDidEndDeceleratingBlock;
}

#pragma mark - UIScrollView delegate

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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollViewDidEndDeceleratingBlock) {
        self.scrollViewDidEndDeceleratingBlock(scrollView);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollViewDidEndDraggingBlock) {
        self.scrollViewDidEndDraggingBlock(scrollView, decelerate);
    }
}

@end
