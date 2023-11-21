//
//  WZPagerView.m
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/11.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import "WZPagerView.h"
@interface WZPagerView () <UITableViewDataSource, UITableViewDelegate, WZPagerListContainerViewDelegate>
@property (nonatomic, weak) id<WZPagerViewDelegate> delegate;
@property (nonatomic, strong) WZPagerMainTableView *mainTableView;
@property (nonatomic, strong) WZPagerListContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;
@property (nonatomic, strong) id<WZPagerViewListViewDelegate> currentList;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, id<WZPagerViewListViewDelegate>> *validListDict;
@property (nonatomic, assign) UIDeviceOrientation currentDeviceOrientation;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL willRemoveFromWindow;
@property (nonatomic, assign) BOOL isFirstMoveToWindow;
@property (nonatomic, strong) WZPagerView *retainedSelf;
@property (nonatomic, strong) WZPagerContainerViewController *containerVC;
@end

@implementation WZPagerView

- (WZPagerContainerViewController *)containerVC {
    if (!_containerVC) {
        _containerVC = [[WZPagerContainerViewController alloc] initWith:self.listContainerView];
        _containerVC.view.backgroundColor = [UIColor clearColor];
    }return _containerVC;
}

- (WZPagerMainTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[WZPagerMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.scrollsToTop = NO;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = UIColor.clearColor;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            self.mainTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _mainTableView;
}

- (WZPagerListContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[WZPagerListContainerView alloc] initWithDelegate:self];
    }return _listContainerView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (instancetype)initWithDelegate:(id<WZPagerViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        _validListDict = [NSMutableDictionary dictionary];
        _automaticallyDisplayListVerticalScrollIndicator = YES;
        _deviceOrientationChangeEnabled = NO;
        [self initializeViews];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (self.isFirstMoveToWindow) {
        //第一次调用过滤，因为第一次列表显示通知会从willDisplayCell方法通知
        self.isFirstMoveToWindow = NO;
        return;
    }
    //当前页面push到一个新的页面时，willMoveToWindow会调用三次。第一次调用的newWindow为nil，第二次调用间隔1ms左右newWindow有值，第三次调用间隔400ms左右newWindow为nil。
    //根据上述事实，第一次和第二次为无效调用，可以根据其间隔1ms左右过滤掉
    if (newWindow == nil) {
        self.willRemoveFromWindow = YES;
        //当前页面被pop的时候，willMoveToWindow只会调用一次，而且整个页面会被销毁掉，所以需要循环引用自己，确保能延迟执行currentListDidDisappear方法，触发列表消失事件。由此可见，循环引用也不一定是个坏事。是天使还是魔鬼，就看你如何对待它了。
        self.retainedSelf = self;
        [self performSelector:@selector(currentListDidDisappear) withObject:nil afterDelay:0.02];
    }else {
        if (self.willRemoveFromWindow) {
            self.willRemoveFromWindow = NO;
            self.retainedSelf = nil;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentListDidDisappear) object:nil];
        }else {
            [self currentListDidAppear];
        }
    }
}

- (void)currentListDidAppear{
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerVC.view.frame = self.bounds;
    self.mainTableView.frame = self.bounds;
}

- (void)setDefaultSelectedRow:(NSInteger)defaultSelectedRow {
    _defaultSelectedRow = defaultSelectedRow;
    self.listContainerView.defaultSelectedIndex = defaultSelectedRow;
    self.currentIndex = defaultSelectedRow;
}

- (void)setIsListHorizontalScrollEnabled:(BOOL)isListHorizontalScrollEnabled {
    _isListHorizontalScrollEnabled = isListHorizontalScrollEnabled;

    self.listContainerView.collectionView.scrollEnabled = isListHorizontalScrollEnabled;
}

- (void)reloadData {
    self.currentList = nil;
    self.currentScrollingListView = nil;

    for (id<WZPagerViewListViewDelegate> list in self.validListDict.allValues) {
        [list.listView removeFromSuperview];
    }
    [_validListDict removeAllObjects];

    [self refreshTableHeaderView];
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
}

#pragma mark - Private

- (void)refreshTableHeaderView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderViewInPagerView:)]) {
        UIView *tableHeaderView = [self.delegate tableHeaderViewInPagerView:self];
        CGFloat height = 0;
        if ([self.delegate respondsToSelector:@selector(tableHeaderViewHeightInPagerView:)]) {
            height = [self.delegate tableHeaderViewHeightInPagerView:self];
        }
        UIView *containerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(tableHeaderView.bounds), height)];
        [containerView addSubview:tableHeaderView];
        self.mainTableView.tableHeaderView = containerView;
    }
}

- (void)adjustMainScrollViewToTargetContentInsetIfNeeded:(UIEdgeInsets)insets {
    if (UIEdgeInsetsEqualToEdgeInsets(insets, self.mainTableView.contentInset) == NO) {
        self.mainTableView.contentInset = insets;
    }
}

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    self.currentScrollingListView = scrollView;

    [self preferredProcessListViewDidScroll:scrollView];
}

- (void)deviceOrientationDidChangeNotification:(NSNotification *)notification {
    if (self.isDeviceOrientationChangeEnabled && self.currentDeviceOrientation != [UIDevice currentDevice].orientation) {
        self.currentDeviceOrientation = [UIDevice currentDevice].orientation;
        //前后台切换也会触发该通知，所以不相同的时候才处理
        [self.mainTableView reloadData];
        [self.listContainerView deviceOrientationDidChanged];
        [self.listContainerView reloadData];
    }
}

- (void)currentListDidDisappear {
    id<WZPagerViewListViewDelegate> list = _validListDict[@(self.currentIndex)];
    if (list && [list respondsToSelector:@selector(listDidDisappear)]) {
        [list listDidDisappear];
    }
    self.willRemoveFromWindow = NO;
    self.retainedSelf = nil;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat sectionHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForPinSectionHeaderInPagerView:)]) {
        sectionHeight = [self.delegate heightForPinSectionHeaderInPagerView:self];
    }
    CGFloat height = self.bounds.size.height - sectionHeight - self.pinSectionHeaderVerticalOffset;
    if (height <= 0) {
        return 0;
    } else {
        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor = UIColor.clearColor;
    self.listContainerView.frame = cell.bounds;
    [cell.contentView addSubview:self.listContainerView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForPinSectionHeaderInPagerView:)]) {
        return [self.delegate heightForPinSectionHeaderInPagerView:self];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewForPinSectionHeaderInPagerView:)]) {
        return [self.delegate viewForPinSectionHeaderInPagerView:self];
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.pinSectionHeaderVerticalOffset != 0) {
        if (scrollView.contentOffset.y < self.pinSectionHeaderVerticalOffset) {
            //因为设置了contentInset.top，所以顶部会有对应高度的空白区间，所以需要设置负数抵消掉
            if (scrollView.contentOffset.y >= 0) {
                [self adjustMainScrollViewToTargetContentInsetIfNeeded:UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)];
            }
        }else if (scrollView.contentOffset.y > self.pinSectionHeaderVerticalOffset){
            //固定的位置就是contentInset.top
            [self adjustMainScrollViewToTargetContentInsetIfNeeded:UIEdgeInsetsMake(self.pinSectionHeaderVerticalOffset, 0, 0, 0)];
        }
    }

    [self preferredProcessMainTableViewDidScroll:scrollView];

    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableViewDidScroll:)]) {
        [self.delegate mainTableViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.listContainerView.collectionView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isListHorizontalScrollEnabled && !decelerate) {
        self.listContainerView.collectionView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isListHorizontalScrollEnabled) {
        self.listContainerView.collectionView.scrollEnabled = YES;
    }
    if (self.mainTableView.contentInset.top != 0 && self.pinSectionHeaderVerticalOffset != 0) {
        [self adjustMainScrollViewToTargetContentInsetIfNeeded:UIEdgeInsetsZero];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.isListHorizontalScrollEnabled) {
        self.listContainerView.collectionView.scrollEnabled = YES;
    }
}

#pragma mark - WZPagingListContainerViewDelegate

- (NSInteger)numberOfRowsInListContainerView:(WZPagerListContainerView *)listContainerView {
    if (self.delegate == nil) {
        return 0;
    }
    return [self.delegate numberOfListsInPagerView:self];
}

- (UIView *)listContainerView:(WZPagerListContainerView *)listContainerView listViewInRow:(NSInteger)row {
    if (self.delegate == nil) {
        return [UIView new];
    }
    id<WZPagerViewListViewDelegate> list = self.validListDict[@(row)];
    if (list == nil) {
        list = [self.delegate pagerView:self initListAtIndex:row];
        __weak typeof(self)weakSelf = self;
        __weak typeof(id<WZPagerViewListViewDelegate>) weakList = list;
        
        if ([list respondsToSelector:@selector(listScrollView)]) {
            [list listScrollView].scrollPagerHandel = ^(UIScrollView * _Nonnull scrollView) {
                weakSelf.currentList = weakList;
                [weakSelf listViewDidScroll:scrollView];
            };
        }
    
        _validListDict[@(row)] = list;
        if ([list isKindOfClass: [UIViewController class]]) {
            [self.containerVC addChildViewController:(UIViewController *)list];
        }
    }
    for (id<WZPagerViewListViewDelegate> listItem in self.validListDict.allValues) {
        if ([listItem respondsToSelector:@selector(listScrollView)]) {
            if (listItem == list) {
                [listItem listScrollView].scrollsToTop = YES;
            }else {
                [listItem listScrollView].scrollsToTop = NO;
            }
        }
    }
    return [list listView];
}

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    [super willMoveToSuperview:newSuperview];
//
//    UIResponder *next = newSuperview;
//    while (next != nil) {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            [((UIViewController *)next) addChildViewController:self.containerVC];
//            break;
//        }
//        next = next.nextResponder;
//    }
//}

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listWillAppear:(NSInteger)row{
    
    id<WZPagerViewListViewDelegate> list = self.validListDict[@(row)];
    if ([list isKindOfClass:[UIViewController class]]) {
        UIViewController *listVC = (UIViewController *)list;
        [listVC beginAppearanceTransition:YES animated:NO];
    }
    
    if (list && [list respondsToSelector:@selector(listWillAppear)]) {
        [list listWillAppear];
    }
}

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listDidAppear:(NSInteger)row{
    self.currentIndex = row;
    if ([self.validListDict[@(row)] respondsToSelector:@selector(listScrollView)]) {
        self.currentScrollingListView = [self.validListDict[@(row)] listScrollView];
    }
    id<WZPagerViewListViewDelegate> list = self.validListDict[@(row)];
    if ([list isKindOfClass:[UIViewController class]]) {
        UIViewController *listVC = (UIViewController *)list;
        [listVC endAppearanceTransition];
    }
    
    if (list && [list respondsToSelector:@selector(listDidAppear)]) {
        [list listDidAppear];
    }
}

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listWillDisappear:(NSInteger)row{
    
    id<WZPagerViewListViewDelegate> list = self.validListDict[@(row)];
    if ([list isKindOfClass:[UIViewController class]]) {
        UIViewController *listVC = (UIViewController *)list;
        [listVC beginAppearanceTransition:NO animated:NO];
    }
    if (list && [list respondsToSelector:@selector(listWillDisappear)]) {
        [list listWillDisappear];
    }
}

- (void)listContainerView:(WZPagerListContainerView *)listContainerView listDidDisappear:(NSInteger)row{
    id<WZPagerViewListViewDelegate> list = self.validListDict[@(row)];
    if ([list isKindOfClass:[UIViewController class]]) {
        UIViewController *listVC = (UIViewController *)list;
        [listVC endAppearanceTransition];
    }
    if (list && [list respondsToSelector:@selector(listDidDisappear)]) {
        [list listDidDisappear];
    }
}

- (NSInteger)currntSelect:(WZPagerListContainerView *)listContainerView {
    return self.currentIndex;
}

- (void)listContainerViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerViewDidScroll:)]) {
        [self.delegate listContainerViewDidScroll:scrollView];
    }
}

- (void)listContainerViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerViewWillBeginDragging:)]) {
        [self.delegate listContainerViewWillBeginDragging:scrollView];
    }
}

- (void)listContainerViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerViewDidEndDragging:willDecelerate:)]) {
        [self.delegate listContainerViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)listContainerViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerViewWillBeginDecelerating:)]) {
        [self.delegate listContainerViewWillBeginDecelerating:scrollView];
    }
}

- (void)listContainerViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerViewDidEndDecelerating:)]) {
        [self.delegate listContainerViewDidEndDecelerating:scrollView];
    }
}


@end

@implementation WZPagerView (UISubclassingGet)

- (CGFloat)mainTableViewMaxContentOffsetY {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderViewHeightInPagerView:)]) {
        return [self.delegate tableHeaderViewHeightInPagerView:self] - self.pinSectionHeaderVerticalOffset;
    }
    return 0;
}

@end

@implementation WZPagerView (UISubclassingHooks)

- (void)initializeViews {
    
    [self addSubview:self.containerVC.view];
    if (self.delegate && [self.delegate respondsToSelector:@selector(superViewController:)]) {
        [[self.delegate superViewController:self] addChildViewController:self.containerVC];
    }
    
    [self.containerVC.view addSubview:self.mainTableView];
    [self refreshTableHeaderView];

    self.listContainerView.mainTableView = self.mainTableView;

    self.isListHorizontalScrollEnabled = YES;

    self.currentDeviceOrientation = [UIDevice currentDevice].orientation;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView {
    if (self.mainTableView.contentOffset.y < self.mainTableViewMaxContentOffsetY) {
        //mainTableView的header还没有消失，让listScrollView一直为0
        if (self.currentList && [self.currentList respondsToSelector:@selector(listScrollViewWillResetContentOffset)]) {
            [self.currentList listScrollViewWillResetContentOffset];
        }
        [self setListScrollViewToMinContentOffsetY:scrollView];
        if (self.automaticallyDisplayListVerticalScrollIndicator) {
            scrollView.showsVerticalScrollIndicator = NO;
        }
    }else {
        //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
        self.mainTableView.contentOffset = CGPointMake(0, self.mainTableViewMaxContentOffsetY);
        if (self.automaticallyDisplayListVerticalScrollIndicator) {
            scrollView.showsVerticalScrollIndicator = YES;
        }
    }
}

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > [self minContentOffsetYInListScrollView:self.currentScrollingListView]) {
        //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
        [self setMainTableViewToMaxContentOffsetY];
    }

    if (scrollView.contentOffset.y < self.mainTableViewMaxContentOffsetY) {
        //mainTableView已经显示了header，listView的contentOffset需要重置
        for (id<WZPagerViewListViewDelegate> list in self.validListDict.allValues) {
            if ([list respondsToSelector:@selector(listScrollViewWillResetContentOffset)]) {
                [list listScrollViewWillResetContentOffset];
            }
            if ([list respondsToSelector:@selector(listScrollView)]) {
                [self setListScrollViewToMinContentOffsetY:[list listScrollView]];
            }
        }
    }

    if (scrollView.contentOffset.y > self.mainTableViewMaxContentOffsetY && self.currentScrollingListView.contentOffset.y == [self minContentOffsetYInListScrollView:self.currentScrollingListView]) {
        //当往上滚动mainTableView的headerView时，滚动到底时，修复listView往上小幅度滚动
        [self setMainTableViewToMaxContentOffsetY];
    }
}

- (void)setMainTableViewToMaxContentOffsetY {
    self.mainTableView.contentOffset = CGPointMake(0, self.mainTableViewMaxContentOffsetY);
}

- (void)setListScrollViewToMinContentOffsetY:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointMake(0, [self minContentOffsetYInListScrollView:scrollView]);
}

- (CGFloat)minContentOffsetYInListScrollView:(UIScrollView *)scrollView {
    if (@available(iOS 11.0, *)) {
        return -scrollView.adjustedContentInset.top;
    }
    return -scrollView.contentInset.top;
}


@end
