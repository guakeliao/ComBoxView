//
//  ComBox.m
//  ComBoxView
//
//  Created by guakeliao on 14/11/16.
//  Copyright (c) 2014年 Boco. All rights reserved.
//

#import "ComBox.h"

@interface ComBox () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation ComBox

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.borderColor = kBorderColor.CGColor;
    self.layer.borderWidth =  0.4;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:self.fontSize >0 ? self.fontSize: 14];
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
    _listTableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height,self.frame.size.width, 0) style:UITableViewStylePlain];
    //    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([_listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_listTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.layer.borderWidth = 0.5;
    _listTableView.layer.borderColor = kBorderColor.CGColor;
    
    [self.superview addSubview:_listTableView];
    
    _titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
}

//刷新视图
- (void)comBoxReloadData
{
    [_listTableView reloadData];
    _titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
    _arrow.image = [UIImage imageNamed:_arrowImgName];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _listTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height,
                                      self.frame.size.width, 0);
    _titleLabel.frame =
    CGRectMake(2, 0, self.frame.size.width - imgW - 5 - 2, self.frame.size.height);
    
    _arrow.frame = CGRectMake(self.frame.size.width - self.frame.size.height,
                              0, self.frame.size.height, self.frame.size.height);
}

//关闭父视图上面的其他combox
- (void)closeOtherCombox
{
    for (UIView *subView in self.superview.subviews)
    {
        if ([subView isKindOfClass:[ComBox class]] && subView != self)
        {
            ComBox *otherCombox = (ComBox *)subView;
            if (otherCombox.isOpen)
            {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     CGRect frame = otherCombox.listTableView.frame;
                                     frame.size.height = 0;
                                     [otherCombox.listTableView setFrame:frame];
                                 }
                                 completion:^(BOOL finished) {
                                     [otherCombox.listTableView removeFromSuperview];
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
                             CGRect frame = _listTableView.frame;
                             frame.size.height = 0;
                             [_listTableView setFrame:frame];
                         }
                         completion:^(BOOL finished) {
                             [_listTableView removeFromSuperview]; //移除
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
                                  注意：如果不加这句话，下面的操作会导致_listTableView从上面飘下来的感觉：
                                  _listTableView展开并且滑动到底部 -> 点击收起 -> 再点击展开
                                  */
                                 [_listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                       atScrollPosition:UITableViewScrollPositionTop
                                                               animated:YES];
                             }
                             
                             [self.superview addSubview:_listTableView];
                             [self.superview bringSubviewToFront:_listTableView]; //避免被其他子视图遮盖住
                             CGRect frame = _listTableView.frame;
                             frame.size.height = _tableHeight > 0 ? _tableHeight : tableH;
                             float height = [UIScreen mainScreen].bounds.size.height;
                             if (frame.origin.y + frame.size.height > height)
                             {
                                 //避免超出屏幕外
                                 frame.size.height -= frame.origin.y + frame.size.height - height;
                             }
                             [_listTableView setFrame:frame];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:self.fontSize ? self.fontSize : 14];
        //        UILabel *label = [[UILabel alloc]init];
        //        label.translatesAutoresizingMaskIntoConstraints = NO;
        //        label.tag = 1000 ;
        //        label.font = [UIFont boldSystemFontOfSize:self.fontSize ? self.fontSize : 14];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        [cell.contentView addSubview:label];
        
        //        [self setEdge:cell view:label attr:NSLayoutAttributeLeft constant:0];
        //        [self setEdge:cell view:label attr:NSLayoutAttributeRight constant:0];
        //        [self setEdge:cell view:label attr:NSLayoutAttributeTop constant:0];
        //        [self setEdge:cell view:label attr:NSLayoutAttributeBottom constant:0];
        //
        //
        //        UILabel *lineLabel = [[UILabel alloc]init];
        //        lineLabel.backgroundColor = kBorderColor;
        //        lineLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //        [cell.contentView addSubview:lineLabel];
        //
        //        [self setEdge:cell view:lineLabel attr:NSLayoutAttributeLeft constant:0];
        //        [self setEdge:cell view:lineLabel attr:NSLayoutAttributeRight constant:0];
        //        [self setEdge:cell view:lineLabel attr:NSLayoutAttributeBottom constant:0];
        //        [self setEdge:lineLabel attr:NSLayoutAttributeHeight relation:NSLayoutRelationEqual constant:1];
    }
    //    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    //    label.text = [_titlesList objectAtIndex:indexPath.row];
    cell.textLabel.text = [_titlesList objectAtIndex:indexPath.row];
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
    [_listTableView deselectRowAtIndexPath:[_listTableView indexPathForSelectedRow] animated:YES];
}
/**
 *  autoLayout 设置距离
 *
 *  @param superview
 *  @param view
 *  @param attr
 *  @param constant
 */
- (void)setEdge:(UIView*)superview view:(UIView*)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr multiplier:1.0 constant:constant]];
}
/**
 *  autoLayout 设置高度
 *
 *  @param superview
 *  @param view
 *  @param attr
 *  @param constant
 */
- (void)setEdge:(UIView*)view attr:(NSLayoutAttribute)attr relation:(NSLayoutRelation)relation constant:(CGFloat)constant
{
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:view
                         attribute:attr
                         relatedBy:relation
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1
                         constant:constant]];
}
@end
