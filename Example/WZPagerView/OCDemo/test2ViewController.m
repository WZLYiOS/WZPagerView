//
//  test2ViewController.m
//  WZPagerView_Example
//
//  Created by qiuqixiang on 2021/3/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "test2ViewController.h"

@interface test2ViewController ()

@end

@implementation test2ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", [NSString stringWithFormat:@"%@：进入界面", self.title]);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%@", [NSString stringWithFormat:@"%@：离开界面", self.title]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
