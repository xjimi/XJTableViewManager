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
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
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

    if (self.style == UITableViewStylePlain)
    {
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // Remove touch delay (since iOS 8)
    /*
    UIView *wrapView = self.subviews.firstObject;
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
    */
    self.data = [NSMutableArray array];
    self.registeredCells = [NSMutableArray array];
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

- (void)setData:(NSMutableArray *)data
{
    if (!data) data = [NSMutableArray array];
    [self registerCellWithData:data];
    _data = data;
    [self reloadData];
}

- (void)insertData:(NSArray *)data
{
    if (!_data) _data = [NSMutableArray array];
    
    [self registerCellWithData:data];
    
    for (XJTableViewDataModel *dataModel in data)
    {
        if (dataModel.section)
        {
            [_data addObject:dataModel];
            NSInteger sectionNum = _data.count - 1;
            [UIView performWithoutAnimation:^{
                [self insertSections:[NSIndexSet indexSetWithIndex:sectionNum] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        else if (dataModel.rows.count)
        {
            XJTableViewDataModel *curDataModel = _data.lastObject;
            [curDataModel.rows addObjectsFromArray:dataModel.rows];
            NSInteger sectionNum = _data.count - 1;
            NSInteger itemNum = curDataModel.rows.count;
            NSLog(@"sectionNum : %ld ::: itemNum : %ld", (long)sectionNum, (long)itemNum);
            NSInteger numberOfRows = [self numberOfRowsInSection:sectionNum];
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSUInteger i = numberOfRows; i < itemNum; i++) {
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:sectionNum]];
            }

            [UIView performWithoutAnimation:^{
                [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }
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
                if([[NSBundle mainBundle] pathForResource:headerReusableId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:headerReusableId bundle:nil];
                    [self registerNib:nib forHeaderFooterViewReuseIdentifier:headerReusableId];
                }
                else
                {
                    Class class = NSClassFromString(headerReusableId);
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
                if([[NSBundle mainBundle] pathForResource:footerReusableId ofType:@"nib"])
                {
                    UINib *nib = [UINib nibWithNibName:footerReusableId bundle:nil];
                    [self registerNib:nib forHeaderFooterViewReuseIdentifier:footerReusableId];
                }
                else
                {
                    Class class = NSClassFromString(footerReusableId);
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
                    if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"])
                    {
                        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
                        [self registerNib:nib forCellReuseIdentifier:cellId];
                    }
                    else
                    {
                        Class class = cellModel.registerClass ? : NSClassFromString(cellId);
                        [self registerClass:class forCellReuseIdentifier:cellId];
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
    if (self.style == UITableViewStylePlain) return dataModel.section.height;
    return dataModel.section.height;// ? : 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    XJTableViewDataModel *dataModel = self.data[section];
    if (self.style == UITableViewStylePlain) return dataModel.footer.height;
    //if (self.data.count != section+1) return dataModel.footer.height ? : CGFLOAT_MIN;
    return dataModel.footer.height;// ? : 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:viewForHeaderInSection:)]) {
        return [self.tableViewDelegate xj_tableView:self viewForHeaderInSection:section];
    }

    XJTableViewDataModel *dataModel = self.data[section];
    XJTableViewHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:dataModel.section.identifier];
    [headerView reloadData:dataModel.section.data];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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
        UITableViewCell *cell = [self.tableViewDelegate xj_tableView:tableView cellForRowAtIndexPath:indexPath];
        if (cell) return cell;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(xj_tableView:moveRowAtIndexPath:toIndexPath:)]) {
        return [self.tableViewDelegate xj_tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
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

@end
