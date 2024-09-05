//
//  UIView+Pager.h
//  Created by ___ORGANIZATIONNAME___ on 2024/9/5
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2024. All rights reserved.
//  @author qiuqixiang(739140860@qq.com)   
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Pager)

/// 滚动回调
@property (strong,nonatomic,nullable) void(^scrollPagerComple)(UIScrollView *scrollView);

@end

NS_ASSUME_NONNULL_END
