//
//  VCViewController.m
//  WZPagingView_Example
//
//  Created by xiaobin liu on 2019/9/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "VCViewController.h"
#import "VCListViewController.h"
#import "VCTwoViewController.h"
#import "VCThreeViewController.h"

@interface VCViewController ()
@end

@implementation VCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id<WZPagerViewListViewDelegate>)pagerView:(WZPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    
    if (index == 0) {
        VCListViewController *listView = [VCListViewController new];
//        [self addChildViewController:listView];
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好"].mutableCopy;
        return  listView;
    }else if (index == 1) {
        VCTwoViewController *listView = [VCTwoViewController new];
        
//        [self addChildViewController:listView];
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好"].mutableCopy;
        return  listView;
    } else if(index == 2) {
        VCThreeViewController *listView = [VCThreeViewController new];
        listView.title = @"第三个";
//        [self addChildViewController:listView];
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好"].mutableCopy;
        return  listView;
    }else {
        VCThreeViewController *listView = [VCThreeViewController new];
        listView.title = @"第四个";
//        [self addChildViewController:listView];
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好"].mutableCopy;
        return  listView;
    }
}

@end
