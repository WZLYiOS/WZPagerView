//
//  TestListBaseView.m
//  WZPagingView_Example
//
//  Created by xiaobin liu on 2019/9/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "TestListBaseView.h"

@interface TestListBaseView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@end

@implementation TestListBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHeaderRefreshed = false;
        
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
//        self.tableView.backgroundColor = [UIColor whiteColor];
//        self.tableView.tableFooterView = [UIView new];
//        self.tableView.dataSource = self;
//        self.tableView.delegate = self;
//        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

- (void)setIsNeedHeader:(BOOL)isNeedHeader {
    _isNeedHeader = isNeedHeader;
    
    __weak typeof(self)weakSelf = self;
    if (self.isNeedHeader) {
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.tableView.mj_header endRefreshing];
//            });
//        }];
    }else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_header removeFromSuperview];
        self.tableView.mj_header = nil;
    }
}

- (void)setIsNeedFooter:(BOOL)isNeedFooter {
    _isNeedFooter = isNeedFooter;
    
    __weak typeof(self)weakSelf = self;
    if (self.isNeedFooter) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.dataSource addObject:@"加载更多成功"];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            });
        }];
    }else {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer removeFromSuperview];
        self.tableView.mj_footer = nil;
    }
}

- (void)beginFirstRefresh {
    if (!self.isHeaderRefreshed) {
        [self beginRefreshImmediately];
    }
}

- (void)beginRefreshImmediately {
    if (self.isNeedHeader) {
        [self.tableView.mj_header beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isHeaderRefreshed = YES;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }else {
        //self.isHeaderRefreshed = YES;
        [self.tableView reloadData];
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isHeaderRefreshed) {
        return 0;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.scrollPagerHandel) {
//        scrollView.scrollPagerHandel(scrollView);
//    }
    self.scrollPagerComple(scrollView);
}

#pragma mark - WZPagingViewListViewDelegate

- (UIView *)listView {
    return self;
}

//- (UIScrollView *)listScrollView {
//    return self.tableView;
//}

- (void)listDidAppear {
    NSLog(@"listDidAppear");
}

- (void)listDidDisappear {
    NSLog(@"listDidDisappear");
}

@end

