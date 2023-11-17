//
//  HeaderRefreshViewController.m
//  WZPagingView_Example
//
//  Created by xiaobin liu on 2019/9/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "MJRefresh.h"
#import "TestListBaseView.h"
#import "HeaderRefreshViewController.h"

@interface HeaderRefreshViewController ()
@end

@implementation HeaderRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedFooter = YES;
    
    __weak typeof(self)weakSelf = self;
//    self.pagerView.collectionView.panGestureRecognizer req
    self.pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //self.isHeaderRefreshed = YES;
            [self.categoryView reloadData];
            [self.pagerView reloadData];
            [weakSelf.pagerView.mainTableView.mj_header endRefreshing];
        });
    }];
}

- (id<WZPagerViewListViewDelegate>)pagerView:(WZPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    TestListBaseView *listView = [[TestListBaseView alloc] init];
    listView.naviController = self.navigationController;
    listView.isHeaderRefreshed = true;
    if (index == 0) {
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",].mutableCopy;
    }else if (index == 1) {
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",].mutableCopy;
    }else {
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",].mutableCopy;
    }
    return listView;
}
@end

