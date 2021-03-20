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
@end

@implementation WZPagerListContainerView

- (instancetype)initWithDelegate:(id<WZPagerListContainerViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        _isFirstLayoutSubviews = YES;
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
    id<WZPagerViewListViewDelegate> listView = [self.delegate listContainerView:self listViewInRow:indexPath.item];
    if (listView != nil) {
        [listView listView].frame = cell.bounds;
        [cell.contentView addSubview:[listView listView]];
    }
    return cell;
}

- (NSInteger)currentIndex{
//    return [NSIndexPath indexPathForItem:self.collectionView.contentOffset.x/self.bounds.size.width inSection:0].item;
    return [self.delegate currntSelect:self];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listWillAppear:)]) {
        [self.delegate listContainerView: self listWillAppear: indexPath.row];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listWillDisappear:)] && [self currentIndex] != indexPath.item) {
        [self.delegate listContainerView: self listWillDisappear: [self currentIndex]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listDidDisappear:)]) {
        [self.delegate listContainerView: self listDidDisappear: indexPath.row];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listDidAppear:)]) {
        NSInteger row = [NSIndexPath indexPathForItem:self.collectionView.contentOffset.x/self.bounds.size.width inSection:0].item;
        [self.delegate listContainerView: self listDidAppear: row];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.mainTableView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.mainTableView.scrollEnabled = YES;
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
