//
//  MJProvince.m
//  03-UIPickerView02-城市选择
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJProvince.h"

@implementation MJProvince

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.cities = dict[@"cities"];
    }
    return self;
}

kInitM(province)

@end
