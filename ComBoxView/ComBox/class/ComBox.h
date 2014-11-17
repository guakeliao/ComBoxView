//
//  ComBox.h
//  ComBoxView
//
//  Created by guakeliao on 14/11/16.
//  Copyright (c) 2014年 Boco. All rights reserved.
//

#import <UIKit/UIKit.h>
#define imgW 10
#define imgH 10
#define tableH 150
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define kBorderColor [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1]
#define kTextColor   [UIColor darkGrayColor]

typedef void (^CheckTitle)(NSString *string);

@interface ComBox : UIView

@property (nonatomic, strong)  UIView *supView;//必须设置
@property (nonatomic, copy)    CheckTitle checkTitle;
@property (nonatomic, strong)  NSMutableArray *titlesList;
@property (nonatomic, assign)  NSInteger defaultIndex;
@property (nonatomic, assign)  CGFloat tableHeight;
@property (nonatomic, copy)    NSString *arrowImgName;//箭头图标名称

/**
 *  关于界面美化
 */
@property (nonatomic, assign) NSInteger cornerRadius;//圆角
@property (nonatomic, assign) UIColor   *borderColor;//边框颜色
@property (nonatomic, assign) NSInteger borderWidth; //边框宽度
//@property (nonatomic, assign) NSInteger cornerRadius;//圆角
/**
 *  必须调用,完善
 */
- (void)commitForView;
/**
 *  当数据更新时，手动调用，刷新数据
 */
-(void)comBoxReloadData;
/**
 *   注意：
 1.单元格默认跟控件本身的高度一致
 */
@end
