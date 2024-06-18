//
//  SingleListViewController.m
//  Created by CocoaPods on 2024/6/17
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

#import "SingleListViewController.h"
#import "WZPagerListRefreshView.h"

@interface SingleListViewController ()

@end

@implementation SingleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isNeedHeader = false;
    self.isNeedFooter = false;
    self.pagerView.isHeaderSendSubviewToBack = true;
}

- (WZPagerView *)preferredPagingView {
    return [[WZPagerListRefreshView alloc] initWithDelegate:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
