//
//  WZPagerView+WZPagerView_JX.m
//  WZPagerView_Example
//
//  Created by qiuqixiang on 2021/3/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "WZPagerView+WZPagerView_JX.h"

@implementation WZPagerView (WZPagerView_JX)

- (UIScrollView *)contentScrollView {
    return self.listContainerView.collectionView;
}

- (void)didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}


- (void)setDefaultSelectedIndex:(NSInteger)index {
    self.defaultSelectedRow = index;
}

@end
