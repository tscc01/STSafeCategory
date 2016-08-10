//
//  ViewController.m
//  STSafeCategory
//
//  Created by Sola on 16/8/10.
//  Copyright © 2016年 tscc-sola. All rights reserved.
//

#import "ViewController.h"
#import "STSafeCategory/STSafeCategory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[STSafeCategory sharedInstance]enableSafeCategory];
    
    NSArray *arrayTest = [[NSArray alloc]initWithObjects:nil count:3];
    arrayTest = [NSArray array];
    id temp = arrayTest[3];
    
    NSMutableArray *arrayMutableTest = [[NSMutableArray alloc]initWithObjects:nil count:3];
    arrayMutableTest = [NSMutableArray array];
    arrayMutableTest[3] = temp;
    temp = arrayMutableTest[3];
    
    NSDictionary *dicTest = [NSDictionary dictionary];
    temp = dicTest[temp];
    
    NSMutableDictionary *dicMutableTest = [NSMutableDictionary dictionary];
    temp = dicMutableTest[temp];
    dicMutableTest[temp] = @"3";
    dicMutableTest[temp] = temp;
    
    NSURL *urlTest = [NSURL fileURLWithPath:temp isDirectory:YES];
    temp = urlTest;
    
    [[NSFileManager defaultManager]enumeratorAtURL:temp includingPropertiesForKeys:temp options:0 errorHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
