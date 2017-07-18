//
//  MJSexBox.m
//  05-键盘处理
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJSexBox.h"

@implementation MJSexBox

#pragma mark 改变了性别选择
- (IBAction)sexChange {
    if (_manBtn.enabled) { // 点击了男的
        _manBtn.enabled = NO;
        _womanBtn.enabled = YES;
    } else { // 点击了女的
        _manBtn.enabled = YES;
        _womanBtn.enabled = NO;
    }
}

+ (id)sexBox
{
    return [[NSBundle mainBundle] loadNibNamed:@"MJSexBox" owner:nil options:nil][0];
}
@end
