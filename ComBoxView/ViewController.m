//
//  ViewController.m
//  ComBoxView
//
//  Created by guakeliao on 14/11/16.
//  Copyright (c) 2014年 Boco. All rights reserved.
//

#import "ViewController.h"
#import "ComBox.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet ComBox *demo;
@property (nonatomic,strong) NSMutableArray *itemsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _demo.checkTitle = ^(NSString *checkTitle)
    {
        NSLog(@"%@",checkTitle);
    };
    _demo.backgroundColor = [UIColor whiteColor];
    _demo.arrowImgName = @"down_dark0.png";
    _itemsArray = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"13",@"12",@"11",]];
    _demo.titlesList = _itemsArray;
    _demo.supView = self.view;
    [_demo reloadData];
}


@end
