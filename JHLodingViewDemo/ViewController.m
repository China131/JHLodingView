//
//  ViewController.m
//  JHLodingViewDemo
//
//  Created by 简豪 on 16/7/1.
//  Copyright © 2016年 codingMan. All rights reserved.
//

#import "ViewController.h"
#import "JHBookPageLoading.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    JHBookPageLoading *book = [[JHBookPageLoading alloc] init];
    book.frame = self.view.bounds;
    
    [self.view addSubview:book];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
