//
//  ViewController.m
//  手势解锁
//
//  Created by mac on 15-9-17.
//  Copyright (c) 2015年 Lispeng. All rights reserved.
//

#import "ViewController.h"
#import "LSPLockView.h"
@interface ViewController ()<LSPLockViewdelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)lockView:(LSPLockView *)lockView didFinishPath:(NSString *)path
{
    NSLog(@"%@",path);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
