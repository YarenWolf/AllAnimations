//
//  MJProvince.h
//  03-UIPickerView02-城市选择
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface MJProvince : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *cities;

kInitH(province)
@end
