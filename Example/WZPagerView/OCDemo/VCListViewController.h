//
//  WZViewController.h
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/11.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestListBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VCListViewController : UIViewController<WZPagerViewListViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray <NSString *> * dataSource;
@end

NS_ASSUME_NONNULL_END
