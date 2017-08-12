//
//  ValuePickerView.h
//  CustomPickerViewDemol
//
//  Created by QianZhang on 16/9/5.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValuePickerView : UIView

/**Picker的标题*/
@property (nonatomic, copy) NSString * pickerTitle;

/**滚轮上显示的数据(必填,会根据数据多少自动设置弹层的高度)*/
@property (nonatomic, strong) NSArray * dataSource;

/**设置默认选项,格式:选项文字/id (先设置dataArr,不设置默认选择第0个)*/
@property (nonatomic, strong) NSString * defaultStr;

/**回调选择的状态字符串(stateStr格式:state/row)*/
@property (nonatomic, copy) void (^valueDidSelect)(NSString * value);

/**显示时间弹层*/
- (void)show;

@end
