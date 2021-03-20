//
//  PagingViewController.m
//  WZPagingView_Example
//
//  Created by xiaobin liu on 2019/9/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "PagingViewController.h"
#import "TestListBaseView.h"
#import "WZPagerView+WZPagerView_JX.h"

@interface PagingViewController ()<JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation PagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self configView];
}

-(void)configView {
    
    [self.view addSubview:self.pagerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = self.view.bounds;
}


- (WZPagerView *)preferredPagingView {
    return [[WZPagerView alloc] initWithDelegate:self];
}

#pragma mark - WZPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(WZPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(WZPagerView *)pagerView {
    return TableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(WZPagerView *)pagerView {
    return heightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(WZPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(WZPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (UIViewController *)superViewController:(WZPagerView *)pagerView {
    return self;
}

- (id<WZPagerViewListViewDelegate>)pagerView:(WZPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    TestListBaseView *listView = [[TestListBaseView alloc] init];
    listView.naviController = self.navigationController;
    listView.isHeaderRefreshed = false;
    listView.isNeedHeader = true;
    listView.isNeedFooter = true;
    if (index == 0) {
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",].mutableCopy;
    }else if (index == 1) {
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",].mutableCopy;
    }else {
        listView.dataSource = @[@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",@"哈哈", @"你好",].mutableCopy;
    }
    [listView beginFirstRefresh];
    return listView;
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
//    [self.pagerView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    [self.pagerView.listContainerView didClickSelectedItemAtIndex:index];
}



#pragma mark - WZPagerMainTableViewGestureDelegate
-(BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - lazy
-(WZPagerView *)pagerView {
    if (!_pagerView) {
        
        _pagerView = [self preferredPagingView];
        _pagerView.mainTableView.gestureDelegate = self;
        _pagerView.defaultSelectedIndex = self.categoryView.defaultSelectedIndex;
        //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
        [_pagerView.listContainerView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        [_pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    return _pagerView;
}


-(NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"社区", @"关注", @"测试", @"是多少"];
    }
    return _titles;
}

-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TableHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}


-(JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, heightForHeaderInSection)];
        _categoryView.titles = self.titles;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
        _categoryView.titleColor = [UIColor blackColor];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.averageCellSpacingEnabled = false;
        
        
        ///要下划线就加这个
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Lengthen;
//        lineView.indicatorLineViewColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
        lineView.indicatorCornerRadius = 1;
        lineView.indicatorWidth = 10;
        lineView.indicatorHeight = 4;
        _categoryView.indicators = @[lineView];
        _categoryView.listContainer = self.pagerView;
        _categoryView.defaultSelectedIndex = 1;
    }
    return _categoryView;
}

@end
