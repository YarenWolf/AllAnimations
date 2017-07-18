//
//  Data.m
//  视图整合练习
//
//  Created by ISD1510 on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "Data.h"

@implementation Data
+ (NSArray *)PieChartData
{
    Data *item1 = [[Data alloc]init];
    item1.color = [UIColor redColor];
    item1.value = 0.27;
    
    Data *item2 = [[Data alloc]init];
    item2.color = [UIColor greenColor];
    item2.value = 0.29;
    
    Data *item3 = [[Data alloc]init];
    item3.color = [UIColor blueColor];
    item3.value = 0.14;
    
    Data *item4 = [[Data alloc]init];
    item4.color = [UIColor purpleColor];
    item4.value = 0.2;
    
    Data *item5 = [[Data alloc]init];
    item5.color = [UIColor yellowColor];
    item5.value = 0.1;
    
    return @[item1,item2,item3,item4,item5];
    
    
}
+(NSArray *)demoData{
    Data *m1=[[Data alloc]init];
    m1.content=@"你好啊，美女！约吗？❤️";
    m1.fromMe=YES;
    Data *m2=[[Data alloc]init];
    m2.content=@"约在哪里？你家我家还是如家？今天明天还是七天？/害羞";
    m2.fromMe=NO;
    Data *m3=[[Data alloc]init];
    m3.content=@"那就来我家吧！👌！";
    m3.fromMe=YES;
    Data *m4=[[Data alloc]init];
    m4.content=@"好的！";
    m4.fromMe=NO;
    return @[m1,m2,m3,m4];
    
    
    
    
    
    
    
    
}


@end
