//
//  WZPagerMainTableView.h
//  WZPagingViewOC
//
//  Created by xiaobin liu on 2019/7/11.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZPagerMainTableViewGestureDelegate <NSObject>

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface WZPagerMainTableView : UITableView
@property (nonatomic, weak) id<WZPagerMainTableViewGestureDelegate> gestureDelegate;
@end
