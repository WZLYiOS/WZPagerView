//
//  UIScrollView+Pager.m
//  WZPagerView
//
//  Created by qiuqixiang on 2020/4/13.
//

#import "UIScrollView+Pager.h"
#import <objc/runtime.h>

@implementation UIScrollView (Pager)

- (void)setScrollPagerHandel:(void (^)(UIScrollView * _Nonnull))scrollPagerHandel{
    objc_setAssociatedObject(self, @selector(scrollPagerHandel), scrollPagerHandel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(UIScrollView * _Nonnull))scrollPagerHandel {
    return objc_getAssociatedObject(self, _cmd);
}

@end
