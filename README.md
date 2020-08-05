# 我主良缘WZPagingView

## Requirements:
- **iOS** 9.0+
- Xcode 10.0+
- Swift 5.0+ 


## Installation Cocoapods
<pre><code class="ruby language-ruby">pod 'WZPagingView', '~> 1.0.0'</code></pre>
<pre><code class="ruby language-ruby">pod 'WZPagingView/Binary', '~> 1.0.0'</code></pre>


## Use
```swift

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
```


## License
WZPagingView is released under an MIT license. See [LICENSE](LICENSE) for more information.

