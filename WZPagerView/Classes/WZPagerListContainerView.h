//
//  WZPagerListContainerView.h
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/11.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZPagerMainTableView;
@class WZPagerListContainerView;
@class WZPagerListContainerCollectionView;

/**
 该协议主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 */
@protocol WZPagerViewListViewDelegate <NSObject>

/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView;

@optional

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView;


/**
 将要重置listScrollView的contentOffset
 */
- (void)listScrollViewWillResetContentOffset;

/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear;

/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear;

@end

@protocol WZPagerListContainerCollectionViewGestureDelegate <NSObject>
@optional
- (BOOL)pagerListContainerCollectionView:(WZPagerListContainerCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)pagerListContainerCollectionView:(WZPagerListContainerCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface WZPagerListContainerCollectionView: UICollectionView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<WZPagerListContainerCollectionViewGestureDelegate> gestureDelegate;
@end

@protocol WZPagerListContainerViewDelegate <NSObject>

- (NSInteger)numberOfRowsInListContainerView:(WZPagerListContainerView *)listContainerView;

- (NSInteger)currntSelect:(WZPagerListContainerView *)listContainerView;

- (id<WZPagerViewListViewDelegate>)listContainerView:(WZPagerListContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listWillAppear:(NSInteger)row;

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listDidAppear:(NSInteger)row;

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listWillDisappear:(NSInteger)row;

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listDidDisappear:(NSInteger)row;

@end


@interface WZPagerListContainerView : UIView

/**
 需要和self.categoryView.defaultSelectedIndex保持一致
 */
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

@property (nonatomic, strong, readonly) WZPagerListContainerCollectionView *collectionView;
@property (nonatomic, weak) WZPagerMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<WZPagerListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

- (void)deviceOrientationDidChanged;

@end


