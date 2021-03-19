//
//  VCTwoViewController.m
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/16.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import "VCTwoViewController.h"


@interface VCTwoViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation VCTwoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"第二个：进入界面");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"第二个：离开界面");
}

-(void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"第二个");
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
