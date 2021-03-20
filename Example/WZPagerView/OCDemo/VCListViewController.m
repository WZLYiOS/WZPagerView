//
//  WZViewController.m
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/11.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import "VCListViewController.h"

@interface VCListViewController ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation VCListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"第一个：进入界面");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"第一个：离开界面");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"第一个：界面完全出现");
}

-(void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"第一个");
    [self.view addSubview: self.tableView];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cccc"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return  cell;
}


#pragma mark - UITableViewDelegate
-(void)setDataSource:(NSArray<NSString *> *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.rowHeight = 50;
        [_tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"cccc"];
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - table
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.scrollPagerHandel) {
        scrollView.scrollPagerHandel(scrollView);
    }
}

#pragma mark - WZPagingViewListViewDelegate
-(UIView *)listView {
    return  self.view;
}

-(UIScrollView *)listScrollView {
    return  self.tableView;
}

@end
