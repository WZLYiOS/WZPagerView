//
//  ListRefreshViewController.m
//  WZPagingView_Example
//
//  Created by xiaobin liu on 2019/9/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "ListRefreshViewController.h"
#import "WZPagerListRefreshView.h"

@interface ListRefreshViewController ()

@end

@implementation ListRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedHeader = YES;
    self.isNeedFooter = NO;
}

- (WZPagerView *)preferredPagingView {
    return [[WZPagerListRefreshView alloc] initWithDelegate:self];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}
@end

