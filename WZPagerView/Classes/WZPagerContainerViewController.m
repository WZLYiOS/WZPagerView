//
//  WZPagerListContainerViewController.m
//  WZPagerView
//
//  Created by qiuqixiang on 2021/3/22.
//

#import "WZPagerContainerViewController.h"

@interface WZPagerContainerViewController ()

@property (nonatomic, weak) id<WZPagerContainerViewControllerDelegate> delegate;

@end

@implementation WZPagerContainerViewController

- (instancetype)initWith:(id<WZPagerContainerViewControllerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }return  self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerListContainerViewController:viewWillAppear:)]) {
        [self.delegate pagerListContainerViewController:self viewWillAppear:animated];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerListContainerViewController:viewDidAppear:)]) {
        [self.delegate pagerListContainerViewController:self viewDidAppear:animated];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerListContainerViewController:viewWillDisappear:)]) {
        [self.delegate pagerListContainerViewController:self viewWillDisappear:animated];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerListContainerViewController:viewDidDisappear:)]) {
        [self.delegate pagerListContainerViewController:self viewDidDisappear:animated];
    }
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
