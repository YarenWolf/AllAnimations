//
//  MJCityPicker.h
//  05-键盘处理
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJCityPicker;

@protocol MJCityPickerDelegate <NSObject>

@optional
- (void)cityPicker:(MJCityPicker *)cityPicker citySelectWithProvince:(NSString *)province city:(NSString *)city;

@end


@interface MJCityPicker : UIView

@property (nonatomic, weak) id<MJCityPickerDelegate> delegate;

+ (id)cityPicker;
@end
