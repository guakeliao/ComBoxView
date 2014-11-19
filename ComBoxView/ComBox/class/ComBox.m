//
//  ComBox.m
//  ComBoxView
//
//  Created by guakeliao on 14/11/16.
//  Copyright (c) 2014年 Boco. All rights reserved.
//

#import "ComBox.h"
#import "ComBoxCell.h"
@interface ComBox () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation ComBox

- (void)commitForView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor = _borderColor.CGColor ? _borderColor.CGColor : kBorderColor.CGColor;
    btn.layer.borderWidth = _borderWidth > 0 ? _borderWidth : 0.4;
    btn.layer.cornerRadius = _cornerRadius;
    btn.clipsToBounds = YES;
    btn.layer.masksToBounds = YES;
    btn.frame = self.bounds;
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:11];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = kTextColor;
    [btn addSubview:_titleLabel];
    
    _arrow = [[UIImageView alloc]
              initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.height,
                                       0, self.frame.size.height, self.frame.size.height)];
    if (!_arrowImgName)
    {
        _arrow.image = [UIImage imageNamed:@"ComBoxView.bundle/down_dark0"];
    }
    else
    {
        _arrow.image = [UIImage imageNamed:_arrowImgName];
    }
    [btn addSubview:_arrow];
    
    //默认不展开
    _isOpen = NO;
    _listTable = [[UITableView alloc]
                  initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height,
                                           self.frame.size.width, 0)
                  style:UITableViewStylePlain];
    _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.layer.borderWidth = 0.5;
    _listTable.layer.borderColor = kBorderColor.CGColor;
    
    [_supView addSubview:_listTable];
    
    _titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
    NSLog(@"%@", _titleLabel.text);
}

//刷新视图
- (void)comBoxReloadData
{
    [_listTable reloadData];
    _titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
    _arrow.image = [UIImage imageNamed:_arrowImgName];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _listTable.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height,
                                  self.frame.size.width, 0);
    _titleLabel.frame =
    CGRectMake(2, 0, self.frame.size.width - imgW - 5 - 2, self.frame.size.height);
    
    _arrow.frame = CGRectMake(self.frame.size.width - self.frame.size.height,
                              0, self.frame.size.height, self.frame.size.height);
}



//关闭父视图上面的其他combox
- (void)closeOtherCombox
{
    for (UIView *subView in _supView.subviews)
    {
        if ([subView isKindOfClass:[ComBox class]] && subView != self)
        {
            ComBox *otherCombox = (ComBox *)subView;
            if (otherCombox.isOpen)
            {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     CGRect frame = otherCombox.listTable.frame;
                                     frame.size.height = 0;
                                     [otherCombox.listTable setFrame:frame];
                                 }
                                 completion:^(BOOL finished) {
                                     [otherCombox.listTable removeFromSuperview];
                                     otherCombox.isOpen = NO;
                                     otherCombox.arrow.transform = CGAffineTransformRotate(
                                                                                           otherCombox.arrow.transform, DEGREES_TO_RADIANS(180));
                                 }];
            }
        }
    }
}
//点击事件
- (void)tapAction
{
    //关闭其他combox
    [self closeOtherCombox];
    
    if (_isOpen)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect frame = _listTable.frame;
                             frame.size.height = 0;
                             [_listTable setFrame:frame];
                         }
                         completion:^(BOOL finished) {
                             [_listTable removeFromSuperview]; //移除
                             _isOpen = NO;
                             _arrow.transform =
                             CGAffineTransformRotate(_arrow.transform, DEGREES_TO_RADIANS(180));
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             if (_titlesList.count > 0)
                             {
                                 /*
                                  
                                  注意：如果不加这句话，下面的操作会导致_listTable从上面飘下来的感觉：
                                  _listTable展开并且滑动到底部 -> 点击收起 -> 再点击展开
                                  */
                                 [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                   atScrollPosition:UITableViewScrollPositionTop
                                                           animated:YES];
                             }
                             
                             [_supView addSubview:_listTable];
                             [_supView bringSubviewToFront:_listTable]; //避免被其他子视图遮盖住
                             CGRect frame = _listTable.frame;
                             frame.size.height = _tableHeight > 0 ? _tableHeight : tableH;
                             float height = [UIScreen mainScreen].bounds.size.height;
                             if (frame.origin.y + frame.size.height > height)
                             {
                                 //避免超出屏幕外
                                 frame.size.height -= frame.origin.y + frame.size.height - height;
                             }
                             [_listTable setFrame:frame];
                         }
                         completion:^(BOOL finished) {
                             _isOpen = YES;
                             _arrow.transform =
                             CGAffineTransformRotate(_arrow.transform, DEGREES_TO_RADIANS(180));
                         }];
    }
}

#pragma mark -tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    ComBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ComBoxCell" owner:nil options:0]firstObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = [_titlesList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _titleLabel.text = [_titlesList objectAtIndex:indexPath.row];
    _isOpen = YES;
    [self tapAction];
    if (_checkTitle)
    {
        _checkTitle([_titlesList objectAtIndex:indexPath.row]);
    }
    [self performSelector:@selector(deSelectedRow) withObject:nil afterDelay:0.2];
}

- (void)deSelectedRow
{
    [_listTable deselectRowAtIndexPath:[_listTable indexPathForSelectedRow] animated:YES];
}

@end
