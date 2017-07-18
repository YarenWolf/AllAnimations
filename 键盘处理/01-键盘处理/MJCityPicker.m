//
//  MJCityPicker.m
//  05-键盘处理
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJCityPicker.h"
#import "MJProvince.h"

@interface MJCityPicker() <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *_provinces;
}
@end

@implementation MJCityPicker

+ (id)cityPicker
{
    return [[NSBundle mainBundle] loadNibNamed:@"MJCityPicker" owner:nil options:nil][0];
}

#pragma mark 任何对象从xib中创建完毕的时候都会调用一次
- (void)awakeFromNib
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil]];
    
    _provinces = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        MJProvince *p = [MJProvince provinceWithDict:dict];
        [_provinces addObject:p];
    }
}

#pragma mark - UIPickerView数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

#pragma mark 第component列有多少行数据
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) { // 多少个省份
        return _provinces.count;
    } else { // 当前选中省份的行数（城市个数）
        // 1.获得选中了哪一个省
        int pIndex = [pickerView selectedRowInComponent:0];
        
        // 2.取出省份模型
        MJProvince *p = _provinces[pIndex];
        
        // 3.返回当前省份城市的个数
        return p.cities.count;
    }
}

#pragma mark - UIPickerView代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) { //显示哪个省份
        // 1.取出省份模型
        MJProvince *p = _provinces[row];
        
        // 2.取出省份名称
        return p.name;
    } else { // 显示哪个城市
        // 1.获得选中了哪一个省
        int pIndex = [pickerView selectedRowInComponent:0];
        
        // 2.取出省份模型
        MJProvince *p = _provinces[pIndex];
        
        // 3.返回对应行的城市名称
        return p.cities[row];
    }
}

#pragma mark 监听选中了某一列的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) { // 改变了省份
        // 刷新第1列的数据(重新刷新数据，重新调用数据源和代理的相应方法获得数据)
        [pickerView reloadComponent:1];
        
        // 选中第1列的第0行
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    // 更改文字
    // 1.获得选中的省份名称
    int pIndex =  [pickerView selectedRowInComponent:0];
    MJProvince *p = _provinces[pIndex];
    
    // 2.获得选中的城市位置
    int cIndex = [pickerView selectedRowInComponent:1];
    
    // 3.通知代理
    if ([_delegate respondsToSelector:@selector(cityPicker:citySelectWithProvince:city:)]) {
        [_delegate cityPicker:self citySelectWithProvince:p.name city:p.cities[cIndex]];
    }
}

@end