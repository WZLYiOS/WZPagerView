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

- (UIView *)listContainerView:(WZPagerListContainerView *)listContainerView listViewInRow:(NSInteger)row;

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

- (void)didClickSelectedItemAtIndex:(NSInteger)index;

- (void)listWillAppear:(NSInteger)row;
- (void)listDidAppear:(NSInteger)row;
- (void)listWillDisappear:(NSInteger)row;
- (void)listDidDisappear:(NSInteger)row;
@end


