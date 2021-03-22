//
//  WZPagerListContainerView.m
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/11.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import "WZPagerListContainerView.h"
#import "WZPagerMainTableView.h"

@interface WZPagerListContainerView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) id<WZPagerListContainerViewDelegate> delegate;
@property (nonatomic, strong) WZPagerListContainerCollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) BOOL isFirstLayoutSubviews;
@property (nonatomic, assign) NSInteger willAppearIndex;
@property (nonatomic, assign) NSInteger willDisappearIndex;
@end

@implementation WZPagerListContainerView

- (instancetype)initWithDelegate:(id<WZPagerListContainerViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        _isFirstLayoutSubviews = YES;
        _willAppearIndex = -1;
        _willDisappearIndex = -1;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collectionView = [[WZPagerListContainerCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    if (@available(iOS 10.0, *)) {
        self.collectionView.prefetchingEnabled = NO;
    }
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.collectionView.frame = self.bounds;
    if (self.selectedIndexPath != nil && [self.delegate numberOfRowsInListContainerView:self] >= self.selectedIndexPath.item + 1) {
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    if (self.isFirstLayoutSubviews) {
        self.isFirstLayoutSubviews = NO;
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.bounds.size.width*self.defaultSelectedIndex, 0) animated:NO];
    }
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)deviceOrientationDidChanged {
    if (self.bounds.size.width > 0) {
        self.selectedIndexPath = [NSIndexPath indexPathForItem:self.collectionView.contentOffset.x/self.bounds.size.width inSection:0];
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfRowsInListContainerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIView *listView = [self.delegate listContainerView:self listViewInRow:indexPath.item];
    listView.frame = cell.bounds;
    [cell.contentView addSubview: listView];
    return cell;
}

- (NSInteger)currentIndex{
    return [self.delegate currntSelect:self];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.mainTableView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.mainTableView.scrollEnabled = YES;
    //滑动到一半又取消滑动处理
    if (self.willDisappearIndex != -1) {
        [self listWillAppear:self.willDisappearIndex];
        [self listWillDisappear:self.willAppearIndex];
        [self listDidAppear:self.willDisappearIndex];
        [self listDidDisappear:self.willAppearIndex];
        self.willDisappearIndex = -1;
        self.willAppearIndex = -1;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.mainTableView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.mainTableView.scrollEnabled = YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (void)listWillAppear:(NSInteger)row{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listWillAppear:)]) {
        /// 控制器首次出现的时候还未添加数据源
        [self.delegate listContainerView:self listViewInRow:row];
        [self.delegate listContainerView: self listWillAppear: row];
    }
}


- (void)listDidAppear:(NSInteger)row{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listDidAppear:)]) {
        [self.delegate listContainerView: self listDidAppear: row];
    }
}

- (void)listWillDisappear:(NSInteger)row{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listWillDisappear:)]) {
        [self.delegate listContainerView: self listWillDisappear: row];
    }
}

- (void)listDidDisappear:(NSInteger)row{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listDidDisappear:)]) {
        [self.delegate listContainerView: self listDidDisappear: row];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging && !scrollView.isTracking && !scrollView.isDecelerating) {
        return;
    }
    CGFloat ratio = scrollView.contentOffset.x/scrollView.bounds.size.width;
    NSInteger maxCount = round(scrollView.contentSize.width/scrollView.bounds.size.width);
    NSInteger leftIndex = floorf(ratio);
    leftIndex = MAX(0, MIN(maxCount - 1, leftIndex));
    NSInteger rightIndex = leftIndex + 1;
    if (ratio < 0 || rightIndex >= maxCount) {
        [self listDidAppearOrDisappear:scrollView];
        return;
    }
    if (rightIndex == self.currentIndex) {
        if (self.willAppearIndex == -1) {
            self.willAppearIndex = leftIndex;
            [self listWillAppear:self.willAppearIndex];
        }
        if (self.willDisappearIndex == -1) {
            self.willDisappearIndex = rightIndex;
            [self listWillDisappear:self.willDisappearIndex];
        }
    }else {
        if (self.willAppearIndex == -1) {
            self.willAppearIndex = rightIndex;
            [self listWillAppear:self.willAppearIndex];
        }
        if (self.willDisappearIndex == -1) {
            self.willDisappearIndex = leftIndex;
            [self listWillDisappear:self.willDisappearIndex];
        }
    }
    [self listDidAppearOrDisappear:scrollView];
}

- (void)listDidAppearOrDisappear:(UIScrollView *)scrollView {

    CGFloat currentIndexPercent = scrollView.contentOffset.x/scrollView.bounds.size.width;
    if (self.willAppearIndex != -1 || self.willDisappearIndex != -1) {
        NSInteger disappearIndex = self.willDisappearIndex;
        NSInteger appearIndex = self.willAppearIndex;
        if (self.willAppearIndex > self.willDisappearIndex) {
            //将要出现的列表在右边
            if (currentIndexPercent >= self.willAppearIndex) {
                self.willDisappearIndex = -1;
                self.willAppearIndex = -1;
                [self listDidDisappear:disappearIndex];
                [self listDidAppear:appearIndex];
            }
        }else {
            //将要出现的列表在左边
            if (currentIndexPercent <= self.willAppearIndex) {
                self.willDisappearIndex = -1;
                self.willAppearIndex = -1;
                [self listDidDisappear:disappearIndex];
                [self listDidAppear:appearIndex];
            }
        }
    }
}

- (BOOL)checkIndexValid:(NSInteger)index {
    NSUInteger count = [self.delegate numberOfRowsInListContainerView:self];
    if (count <= 0 || index >= count) {
        return NO;
    }
    return YES;
}

- (void)didClickSelectedItemAtIndex:(NSInteger)index {
    if (![self checkIndexValid:index]) {
        return;
    }
    self.willAppearIndex = -1;
    self.willDisappearIndex = -1;
    if (self.currentIndex != index) {
        [self listWillDisappear:self.currentIndex];
        [self listDidDisappear:self.currentIndex];
        [self listWillAppear:index];
        [self listDidAppear:index];
    }
}

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewWillAppear:(BOOL)animated{
    [self listWillAppear:[self currentIndex]];
}

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewDidAppear:(BOOL)animated{
    [self listDidAppear:[self currentIndex]];
}

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewWillDisappear:(BOOL)animated{
    [self listWillDisappear:[self currentIndex]];
}

- (void)pagerListContainerViewController:(WZPagerContainerViewController *)controller viewDidDisappear:(BOOL)animated{
    [self listDidDisappear:[self currentIndex]];
}

@end


@interface WZPagerListContainerCollectionView ()

@end

@implementation WZPagerListContainerCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(pagerListContainerCollectionView:gestureRecognizerShouldBegin:)]) {
        return [self.gestureDelegate pagerListContainerCollectionView:self gestureRecognizerShouldBegin:gestureRecognizer];
    }else {
        if (self.isNestEnabled) {
            if ([gestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
                CGFloat velocityX = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view].x;
                //x大于0就是往右滑
                if (velocityX > 0) {
                    if (self.contentOffset.x == 0) {
                        return NO;
                    }
                }else if (velocityX < 0) {
                    //x小于0就是往左滑
                    if (self.contentOffset.x + self.bounds.size.width == self.contentSize.width) {
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(pagerListContainerCollectionView:gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.gestureDelegate pagerListContainerCollectionView:self gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return NO;
}

@end
