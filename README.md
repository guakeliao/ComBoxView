ComBox
======

下拉框
  
How to use
======

    _demo.checkTitle = ^(NSString *checkTitle)
    {
        NSLog(@"%@",checkTitle);
    };
    _demo.backgroundColor = [UIColor whiteColor];
    //    _demo.arrowImgName = @"down_dark0.png";
    _itemsArray = [NSMutableArray arrayWithArray:@[@"1",@"1",@"1",@"13",@"12",@"11",]];
    _demo.titlesList = _itemsArray;
    _demo.supView = self.view;
    _demo.cornerRadius = 3;
    _demo.borderWidth = 2;
    _demo.borderColor = [UIColor redColor];
    [_demo commitForView];