//
//  AlbumsViewController.m
//  Demo
//
//  Created by XJIMI on 2019/6/4.
//  Copyright © 2019 XJIMI. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumModel.h"
#import "AlbumCell.h"
#import "AlbumHeader.h"
#import <Masonry/Masonry.h>

@interface AlbumsViewController ()

@property (nonatomic, strong) XJTableViewManager *tableView;

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UIView *controlsView;

@end

@implementation AlbumsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    

    [self createTableView];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        // Fallback on earlier versions
    }
    [self reloadData];
}

- (void)reloadData {
    self.tableView.data = @[[self createDataModel]].mutableCopy;
}

- (XJTableViewHeaderModel *)createHeaderModel
{
    NSString *setion = [NSString stringWithFormat:@"New Album %ld", (long)self.tableView.data.count];
    XJTableViewHeaderModel *headerModel = [XJTableViewHeaderModel
                                           modelWithReuseIdentifier:[AlbumHeader identifier]
                                           headerHeight:50.0f
                                           data:setion];
    return headerModel;
}

- (IBAction)action_insertSection
{
    if (!self.inputField.text.length) return;
    
    NSInteger sectionIndex = [self.inputField.text integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XJTableViewDataModel *dataModel = [self createDataModel];
        [self.tableView insertDataModel:dataModel atSectionIndex:sectionIndex];
    });
}

- (IBAction)action_appendRows
{
    if (!self.inputField.text.length) return;
    
    NSInteger sectionIndex = [self.inputField.text integerValue];
    if (sectionIndex >= self.tableView.data.count) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        XJTableViewDataModel *dataModel = [self.tableView.data objectAtIndex:sectionIndex];
        XJTableViewDataModel *newDataModel = [XJTableViewDataModel
                                              modelWithSection:dataModel.section
                                              rows:[self createRows]];
        [self.tableView appendRowsWithDataModel:newDataModel];
        
    });

}


- (NSMutableArray *)createRows
{
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        AlbumModel *model = [[AlbumModel alloc] init];
        model.albumName = @"Scorpion (OVO Updated Version) [iTunes][2018]";
        model.artistName = @"Drake";
        model.imageName = @"drake";
        
        XJTableViewCellModel *cellModel = [XJTableViewCellModel
                                           modelWithReuseIdentifier:[AlbumCell identifier]
                                           cellHeight:80.0f
                                           data:model];
        [rows addObject:cellModel];
    }
    return rows;
}

- (XJTableViewDataModel *)createDataModel
{
    XJTableViewDataModel *dataModel = [XJTableViewDataModel
                                       modelWithSection:[self createHeaderModel]
                                       rows:[self createRows]];
    return dataModel;
}

- (void)action_createDataModel
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XJTableViewDataModel *dataModel = [self createDataModel];
        [self.tableView addDataModel:dataModel];
    });
}

- (void)createTableView
{
    XJTableViewManager *tableView = [XJTableViewManager managerWithStyle:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithWhite:0.1020 alpha:1.0000];
    [self.view addSubview:tableView];

   // __weak typeof(self)weakSelf = self;
    [tableView addWillDisplayCellBlock:^(XJTableViewCellModel *cellModel,
                                          XJTableViewCell *cell,
                                          NSIndexPath *indexPath)
     {
         /*
         if (cell.alpha == 0.0f) return;
         cell.alpha = 0.0f;
         [UIView animateWithDuration:.6
                               delay:0
                             options:UIViewAnimationOptionAllowUserInteraction
                          animations:^
          {
              cell.alpha = 1.0f;
          } completion:nil];*/

     }];

    [tableView addDidSelectRowBlock:^(XJTableViewCellModel *cellModel, NSIndexPath *indexPath) {

        //AlbumsViewController *vc = [[AlbumsViewController alloc] init];
        //[weakSelf.navigationController pushViewController:vc animated:YES];
        //[self action_createDataModel];

    }];

    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.controlsView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);


    }];

    self.tableView = tableView;
}


@end
