//
//  TestListBaseView.h
//  WZPagingView_Example
//
//  Created by xiaobin liu on 2019/9/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "MJRefresh.h"
#import <UIKit/UIKit.h>
#import "WZPagerView.h"

/**
 TestListBaseView
 */
@interface TestListBaseView : UIView <WZPagerViewListViewDelegate>

@property (nonatomic, weak) UINavigationController *naviController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *> *dataSource;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, assign) BOOL isHeaderRefreshed;   //默认为YES
- (void)beginFirstRefresh;

@end
