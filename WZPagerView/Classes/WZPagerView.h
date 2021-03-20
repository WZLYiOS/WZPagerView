//
//  WZPagerView.h
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/11.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+Pager.h"
#import "WZPagerMainTableView.h"
#import "WZPagerListContainerView.h"

#define WZPagerViewDeprecated(instead) NS_DEPRECATED(9_0, 9_0, 9_0, 9_0, instead)

@class WZPagerView;

@protocol WZPagerViewDelegate <NSObject>

/**
 返回列表的数量

 @param pagerView pagerView description
 @return 列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(WZPagerView *)pagerView;

/**
 根据index初始化一个对应列表实例，需要是遵从`WZPagerViewListViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`WZPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`WZPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
 注意：一定要是新生成的实例！！！

 @param pagerView pagerView description
 @param index index description
 @return 新生成的列表实例
 */
- (id<WZPagerViewListViewDelegate>)pagerView:(WZPagerView *)pagerView initListAtIndex:(NSInteger)index;

@optional

/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数

 @param pagerView pagerView description
 @return return tableHeaderView的高度
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(WZPagerView *)pagerView;

/**
 返回tableHeaderView

 @param pagerView pagerView description
 @return tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(WZPagerView *)pagerView;

/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数

 @param pagerView pagerView description
 @return 悬浮HeaderView的高度
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(WZPagerView *)pagerView;

/**
 返回悬浮HeaderView

 @param pagerView pagerView description
 @return 悬浮HeaderView
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(WZPagerView *)pagerView;

/**
 mainTableView的滚动回调，用于实现头图跟随缩放

 @param scrollView mainTableView
 */
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface WZPagerView : UIView
/**
 需要和self.categoryView.defaultSelectedIndex保持一致
 */
@property (nonatomic, assign) NSInteger defaultSelectedIndex;
@property (nonatomic, strong, readonly) WZPagerMainTableView *mainTableView;
@property (nonatomic, strong, readonly) WZPagerListContainerView *listContainerView;
/**
 当前已经加载过可用的列表字典，key就是index值，value是对应的列表。
 */
@property (nonatomic, strong, readonly) NSDictionary <NSNumber *, id<WZPagerViewListViewDelegate>> *validListDict;
/**
 顶部固定sectionHeader的垂直偏移量。数值越大越往下沉。
 */
@property (nonatomic, assign) NSInteger pinSectionHeaderVerticalOffset;
/**
 是否支持设备旋转，默认为NO
 */
@property (nonatomic, assign, getter=isDeviceOrientationChangeEnabled) BOOL deviceOrientationChangeEnabled;
/**
 是否允许列表左右滑动。默认：YES
 */
@property (nonatomic, assign) BOOL isListHorizontalScrollEnabled;
/**
 是否允许当前列表自动显示或隐藏列表是垂直滚动指示器。YES：悬浮的headerView滚动到顶部开始滚动列表时，就会显示，反之隐藏。NO：内部不会处理列表的垂直滚动指示器。默认为：YES。
 */
@property (nonatomic, assign) BOOL automaticallyDisplayListVerticalScrollIndicator;

- (instancetype)initWithDelegate:(id<WZPagerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (void)reloadData;
- (void)refreshTableHeaderView;
@end

@interface WZPagerView (UISubclassingGet)
/**
 暴露给子类使用，请勿直接使用该属性！
 */
@property (nonatomic, strong, readonly) UIScrollView *currentScrollingListView;
/**
 暴露给子类使用，请勿直接使用该属性！
 */
@property (nonatomic, strong, readonly) id<WZPagerViewListViewDelegate> currentList;
@property (nonatomic, assign, readonly) CGFloat mainTableViewMaxContentOffsetY;
@end

@interface WZPagerView (UISubclassingHooks)
- (void)initializeViews NS_REQUIRES_SUPER;
- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView;
- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView;
- (void)setMainTableViewToMaxContentOffsetY;
- (void)setListScrollViewToMinContentOffsetY:(UIScrollView *)scrollView;
- (CGFloat)minContentOffsetYInListScrollView:(UIScrollView *)scrollView;
@end

