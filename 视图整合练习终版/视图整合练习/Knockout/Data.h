//
//  Data.h
//  视图整合练习
//
//  Created by ISD1510 on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Data : NSObject
@property(nonatomic,strong)UIColor *color;
@property(nonatomic,assign)CGFloat value;
+(NSArray *)PieChartData;
//我的微信数据
@property(nonatomic,strong)NSString *content;
@property(nonatomic)BOOL fromMe;
+(NSArray*)demoData;
@end
