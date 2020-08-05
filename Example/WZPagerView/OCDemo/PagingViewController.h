//
//  PagingViewController.h
//  WZPagingView_Example
//
//  Created by xiaobin liu on 2019/9/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZPagerView.h"
#import "JXCategoryView.h"
#import "JXCategoryTitleView.h"

NS_ASSUME_NONNULL_BEGIN
static const CGFloat TableHeaderViewHeight = 200;
static const CGFloat heightForHeaderInSection = 50;

@interface PagingViewController : UIViewController<WZPagerViewDelegate, WZPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) WZPagerView *pagerView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
- (WZPagerView *)preferredPagingView;

@end

NS_ASSUME_NONNULL_END
