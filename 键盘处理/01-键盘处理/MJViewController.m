//
//  MJViewController.m
//  05-键盘处理
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJViewController.h"
#import "MJSexBox.h"
#import "MJKeyboardTool.h"
#import "MJCityPicker.h"

@interface MJViewController () <UITextFieldDelegate, MJCityPickerDelegate, MJKeyboardToolDelegate>
{
    NSMutableArray *_fields; // 所有的文本输入框
    UITextField *_focusedField; // 聚焦的文本框
    MJKeyboardTool *_tool;
}
@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.设置键盘
    [self settingKeyboard];
    
    // 2.添加性别选择控件
    [self addSexBox];
    
    // 3.处理所有的文本输入框
    [self dealFields];
    
    // 4.监听系统发出的键盘通知
    [self addKeyboardNote];
}

#pragma mark - 键盘处理
#pragma mark 监听系统发出的键盘通知
- (void)addKeyboardNote
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 显示一个新的键盘就会调用
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取得当前聚焦文本框最下面的Y值
    CGFloat fieldMaxY = CGRectGetMaxY(_focusedField.frame);
    
//    CGRect fieldRect = [_focusedField.superview convertRect:_focusedField.frame toView:self.view];
//    CGFloat fieldMaxY = CGRectGetMaxY(fieldRect);
    
//    CGRect rect =  [self.view convertRect:_birthdayField.frame toView:abc];
    
    
    // 2.计算键盘的Y值
    // 2.1.取出键盘的高度
    CGFloat keyboardH = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 2.2.控制器view的高度 - 键盘的高度
    CGFloat keyboardY = self.view.frame.size.height - keyboardH;
    
    // 3.比较 文本框最大Y 跟 键盘Y
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (duration <= 0.0) {
        duration = 0.25;
    }
    
    [UIView animateWithDuration:duration animations:^{
        if (fieldMaxY > keyboardY) { // 键盘挡住了文本框
            self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - fieldMaxY - 10);
        } else { // 没有挡住文本框
            self.view.transform = CGAffineTransformIdentity;
        }
    }];
}

#pragma mark 隐藏键盘就会调用
- (void)keyboardWillHide:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 其他方法
#pragma mark 处理所有的文本框
- (void)dealFields
{
    // 1.初始化数组
    _fields = [NSMutableArray array];
    
    // 2.创建键盘工具条
    MJKeyboardTool *tool = [MJKeyboardTool keyboardTool];
    tool.delegate = self;
//    
//    tool.previousItem = nil;
    
#warning 递归遍历找出所有的文本框控件
    // 3.遍历控制器view所有的子控件，找出文本框控件
    for (UIView *child in self.view.subviews) {
        // 如果是文本输入框
        if ([child isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)child;
            
            field.inputAccessoryView = tool; // 设置工具条
            field.delegate = self; // 设置代理
            
            // 增加文本框
            [_fields addObject:field];
        }
    }
    _tool = tool;
    
    // 4.对所有的文本框控件进行排序
    [_fields sortUsingComparator:^NSComparisonResult(UITextField *obj1, UITextField *obj2) {
        /*
         NSOrderedAscending = -1L, // 右边的对象排后面
         NSOrderedSame, // 一样
         NSOrderedDescending // 左边的对象排后面
         */
        
        CGFloat obj1Y = obj1.frame.origin.y;
        CGFloat obj2Y = obj2.frame.origin.y;
        
        if (obj1Y > obj2Y) { // obj1排后面
            return NSOrderedDescending;
        } else { // obj1排前面
            return NSOrderedAscending;
        }
    }];
    
    /*
    NSArray *array = @[@1, @20, @3, @10, @2];
    // sortedArrayUsingComparator:方法并不会改变array数组内部的顺序
    // sortedArrayUsingComparator:方法会返回一个新的已经排好序的数组
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    NSLog(@"%@", sortedArray);
     */
}

#pragma mark 添加性别控件
- (void)addSexBox
{
    MJSexBox *sexBox = [MJSexBox sexBox];
    sexBox.center = CGPointMake(150, 70);
    [self.view addSubview:sexBox];
}

#pragma mark 设置键盘
- (void)settingKeyboard
{
    // 1.生日
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate; // 只显示日期5
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(birthdayChange:) forControlEvents:UIControlEventValueChanged];
    _birthdayField.inputView = datePicker; // 设置键盘为日期选择控件
//    _birthdayField.delegate = self;
    
    // 1.地址
    MJCityPicker *cityPicker = [MJCityPicker cityPicker];
    
    cityPicker.delegate = self;
    _cityField.inputView = cityPicker; // 设置键盘为pickerview
//    _cityField.delegate = self;
}

#pragma mark - MJKeyboardTool代理方法
#pragma mark 点击了工具条上面的按钮就会调用
- (void)keyboardTool:(MJKeyboardTool *)keyboardTool itemClick:(MJKeyboardToolItemType)itemType
{
    if (itemType == MJKeyboardToolItemTypeDone) {// 完成
        [self.view endEditing:YES];
    } else { // 上一个\下一个
        // 拿到前面\后面的一个文本框，让它成为第一响应者
        int index = [_fields indexOfObject:_focusedField];
        
        if (itemType == MJKeyboardToolItemTypeNext) {
            index++;
        } else {
            index--;
        }
        
        [_fields[index] becomeFirstResponder];
    }
}

#pragma mark - MJCityPicker代理方法
#pragma mark 选中了某个城市就会调用
- (void)cityPicker:(MJCityPicker *)cityPicker citySelectWithProvince:(NSString *)province city:(NSString *)city
{
    _cityField.text = [NSString stringWithFormat:@"%@ %@", province, city];
}

#pragma mark - 生日改变
- (void)birthdayChange:(UIDatePicker *)picker
{
    // 1.取得当前时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *time = [fmt stringFromDate:picker.date];
    
    // 2.赋值到文本框
    _birthdayField.text = time;
}

#pragma mark - UITextField代理
#pragma mark 当文本框开始编辑的时候调用---开始聚焦
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _focusedField = textField;
    
    // 判断当前聚焦的文本框是否为最前面或者最后面的文本框
    int index = [_fields indexOfObject:textField];
    
//    if (index == 0) { // 最前面
//        _tool.previousItem.enabled = NO;
//    } else {
//        _tool.previousItem.enabled = YES;
//    }
    // 如果不是第0个文本框，“上一个”可以被点击
    _tool.previousItem.enabled = index != 0;
    // 如果不是最后一个文本框，“下一个”可以被点击
    _tool.nextItem.enabled = index != (_fields.count - 1);
    
//    [self keyboardWillShow:<#(NSNotification *)#>];
    
//    [UIApplication sharedApplication].windows;
}

#pragma mark 每当用户输入文字的时候就会调用这个方法，返回NO，禁止输入；但会YES，允许输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == _birthdayField || textField == _cityField) return NO;
//    return YES;
    
//    return (textField == _birthdayField || textField == _cityField) ? NO : YES;
    
    return !(textField == _birthdayField || textField == _cityField);
}
@end