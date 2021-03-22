//
//  WZPagerListContainerViewController.h
//  WZPagerView
//
//  Created by qiuqixiang on 2021/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WZPagerContainerViewController;
@protocol WZPagerContainerViewControllerDelegate <NSObject>

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewWillAppear:(BOOL)animated;

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewDidAppear:(BOOL)animated;

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewWillDisappear:(BOOL)animated;

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewDidDisappear:(BOOL)animated;

@end

@interface WZPagerContainerViewController : UIViewController

- (instancetype)initWith:(id<WZPagerContainerViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
