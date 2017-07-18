
//
//  MyTabBarController.m
//  视图整合练习
//
//  Created by ISD1510 on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MyTabBarController.h"
#import "MyTabBar.h"
#import "WeChartViewController.h"
#import "MyNavigationController.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "WeChartViewController.h"

@interface MyTabBarController ()<MyTabBarDelegate>

@end

@implementation MyTabBarController
-(void)MyTabBarDidClickCenterButton:(MyTabBar *)tabBar{
    WeChartViewController *WeChartC=[self.storyboard instantiateViewControllerWithIdentifier:@"wechartNavigationController"];
    [self presentViewController:WeChartC animated:YES completion:nil];
    
}


#pragma mark 添加一个子控制器
-(void)setUpOneChildViewController:(UIViewController *)viewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewController *home = [[ViewController alloc] init];
    [self setUpOneChildViewController:home image:@"tab_home" selectedImage:@"tab_home_select" title:@"讲解"];
    UIViewController *root = [[UIViewController alloc]init];
    [self setUpOneChildViewController:root image:@"tab_home" selectedImage:@"tab_home" title:@"aaa"];
    UIViewController *third = [[UIViewController alloc]init];
    [self setUpOneChildViewController:third image:@"tab_home" selectedImage:@"tab_home" title:@"bbb"];
    SecondViewController *profile = [[SecondViewController alloc] init];
    [self setUpOneChildViewController:profile image:@"tab_me" selectedImage:@"tab_me_select" title:@"我的"];
    
    //遍历TabBarController管理的所有子vc//通过这个子vc拿到与此vc关联的那个UITabBarItem//才能修改里面被选中的图片的渲染模式
    for (UIViewController *vc in self.viewControllers){
        UIImage *selectedImage = vc.tabBarItem.selectedImage;
        vc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //获取UITabbarItem的样品实例
    UITabBarItem *barItem = [UITabBarItem appearance];
    //保存正常状态下的文本属性
    NSMutableDictionary *normalAttributes = [NSMutableDictionary dictionary];
    normalAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    normalAttributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    [barItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    //保存选中状态下的文本属性
    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
    selectedAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0  alpha:1.0];
    [barItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    //2.替换系统自带的tabbar
    MyTabBar *tabbar = [[MyTabBar alloc]init];
    tabbar.delegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
}
@end
