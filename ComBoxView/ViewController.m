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
//    _demo.arrowImgName = @"down_dark0.png";
    _itemsArray = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"13",@"12",@"11",]];
    _demo.titlesList = _itemsArray;
    _demo.fontSize = 11;
    _demo.layer.cornerRadius = 2;
    _demo.layer.borderWidth = YES;
    _demo.layer.borderColor = [UIColor redColor].CGColor;
    _demo.clipsToBounds = YES;
    _demo.layer.masksToBounds = YES;

//    [_demo comBoxReloadData];
}


@end
