//
//  UIScrollView+Pager.h
//  WZPagerView
//
//  Created by qiuqixiang on 2020/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Pager)

/// 滚动回调
@property (strong,nonatomic,nullable) void(^scrollPagerHandel)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
