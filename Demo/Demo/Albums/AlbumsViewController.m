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
#import "AlbumFooter.h"
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
    [self reloadData];
}

#pragma mark - Create XJTableView and dataModel

- (void)createTableView
{
    XJTableViewManager *tableView = [XJTableViewManager managerWithStyle:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor lightGrayColor];
    [tableView disableGroupHeaderHeight];
    [tableView disableGroupFooterHeight];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.controlsView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

    self.tableView = tableView;


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView updateCellModelAtIndexPath:indexPath
                              updateCellModelBlock:^XJTableViewCellModel * _Nullable(XJTableViewCellModel * _Nullable cellModel) {

            AlbumModel *albumModel = cellModel.data;
            albumModel.albumName = @"abbbbbb";
            cellModel.height = 130;
            return cellModel;

        }];

        /*
        NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath *indexPath_2 = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView updateCellModelsAtIndexPaths:@[indexPath, indexPath_1, indexPath_2]
                               updateCellModelsBlock:^NSArray * _Nullable(NSArray * _Nullable cellModels) {


            for (XJTableViewCellModel *cellModel in cellModels) {
                AlbumModel *albumModel = cellModel.data;
                albumModel.albumName = @"abbbbbb";
                cellModel.height = 100;
            }

            return cellModels;
        }];
         */

    });

}

- (void)reloadData {
    [self.tableView refreshDataModel:[self createDataModelWithIndex:0]];
}

- (XJTableViewDataModel *)createDataModelWithIndex:(NSInteger)index
{
    XJTableViewDataModel *dataModel = [XJTableViewDataModel
                                       modelWithHeader:[self createHeaderModelWithIndex:index]
                                       footer:[self createFooterModelWithIndex:index]
                                       rows:[self createRows]];
    return dataModel;
}

- (XJTableViewHeaderModel *)createHeaderModelWithIndex:(NSInteger)index
{
    NSString *setion = [NSString stringWithFormat:@"New Album %ld", (long)self.tableView.allDataModels.count + index];
    XJTableViewHeaderModel *headerModel = [XJTableViewHeaderModel
                                           modelWithReuseIdentifier:[AlbumHeader identifier]
                                           headerHeight:50.0f
                                           data:setion];
    return headerModel;
}

- (XJTableViewFooterModel *)createFooterModelWithIndex:(NSInteger)index
{
    NSString *setion = [NSString stringWithFormat:@"footer %ld", (long)self.tableView.allDataModels.count + index];
    XJTableViewFooterModel *footerModel = [XJTableViewFooterModel
                                           modelWithReuseIdentifier:[AlbumFooter identifier]
                                           footerHeight:50.0f
                                           data:setion];
    return footerModel;
}


- (NSMutableArray *)createRows
{
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        AlbumModel *model = [[AlbumModel alloc] init];
        model.albumName = @"Scorpion (OVO Updated Version) [iTunes][2018]";
        model.artistName = [NSString stringWithFormat:@"%f - Drake", time];
        model.imageName = @"drake";
        
        XJTableViewCellModel *cellModel = [XJTableViewCellModel
                                           modelWithReuseIdentifier:[AlbumCell identifier]
                                           cellHeight:80.0f
                                           data:model];
        [rows addObject:cellModel];
    }
    return rows;
}

#pragma mark - Controls Action

- (IBAction)action_appendRows
{
    if (!self.inputField.text.length) return;

    NSInteger sectionIndex = [self.inputField.text integerValue];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        XJTableViewHeaderModel *header = nil;
        if (sectionIndex < self.tableView.allDataModels.count)
        {
            XJTableViewDataModel *dataModel = [self.tableView.allDataModels objectAtIndex:sectionIndex];
            header = dataModel.header;
        }

        XJTableViewDataModel *newDataModel = [XJTableViewDataModel
                                              modelWithHeader:header
                                              rows:[self createRows]];
        [self.tableView appendRowsWithDataModel:newDataModel];

    });
}

- (IBAction)action_appendDataModel
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSMutableArray *dataModels = [NSMutableArray array];
        for (NSInteger i = 0 ; i < 3; i ++) {

            /*XJTableViewHeaderModel *headerModel = [XJTableViewHeaderModel emptyModel];
            XJTableViewDataModel *newDataModel = [XJTableViewDataModel
                                                  modelWithSection:headerModel
                                                  rows:[self createRows]];*/

            XJTableViewDataModel *dataModel = [self createDataModelWithIndex:i];
            [dataModels addObject:dataModel];
        }
        [self.tableView appendDataModels:dataModels];

    });
}

- (IBAction)action_insertSection
{
    if (!self.inputField.text.length) return;

    //NSInteger sectionIndex = [self.inputField.text integerValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        NSMutableArray *dataModels = [NSMutableArray array];
        for (NSInteger i = 0 ; i < 1; i ++) {
            XJTableViewDataModel *dataModel = [self createDataModelWithIndex:i];
            [dataModels addObject:dataModel];
        }

        [self.tableView insertDataModels:dataModels atSectionIndex:0];

    });
}


@end
