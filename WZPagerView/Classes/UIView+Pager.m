//
//  UIView+Pager.m
//  Created by ___ORGANIZATIONNAME___ on 2024/9/5
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

#import "UIView+Pager.h"
#import <objc/runtime.h>

@implementation UIView (Pager)

- (void)setScrollPagerComple:(void (^)(UIScrollView * _Nonnull))scrollPagerComple{
    objc_setAssociatedObject(self, @selector(scrollPagerComple), scrollPagerComple, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(UIScrollView * _Nonnull))scrollPagerComple {
    return objc_getAssociatedObject(self, _cmd);
}

@end
