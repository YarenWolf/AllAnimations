//
//  MyNavigationController.m
//  视图整合练习
//
//  Created by ISD1510 on 16/1/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*第一次使用这个类或者这个类的的子类的时候调用*/
+(void)initialize
{
    //使用Appearance对导航栏统一外观设置
    UINavigationBar *bar = [UINavigationBar appearance];
    
    // 设置导航条的背景色
    //[bar setBarTintColor:[UIColor redColor]];
    
    //1.设置背景图
    [bar setBackgroundImage:[UIImage imageNamed:@"navibg"] forBarMetrics:UIBarMetricsDefault];
    //2.设置导航栏的样式（设置为black色系时，影响状态栏为白色字）
    [bar setBarStyle:UIBarStyleBlack];
    //3.设置左右按钮的渲染颜色
    [bar setTintColor:[UIColor whiteColor]];
    //4.设置导航栏中标题文字的竖直方向位置
    //[bar setTitleVerticalPositionAdjustment:-20 forBarMetrics:UIBarMetricsDefault];
    //5.设置导航栏中标题文字的样式
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    //添加文字颜色的设置
    attributes[NSForegroundColorAttributeName] = [UIColor yellowColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [bar setTitleTextAttributes:attributes];
    //6.设置返回按钮的箭头
    [bar setBackIndicatorImage:[UIImage imageNamed:@"back_btn"]];
    [bar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back_btn"]];
}

//为了方便只要一push出二级页面，就自动隐藏底部的bar
//截获导航控制器的pushViewController方法
//先保证原有的push动作要完成，除此意外再多做一件事
//隐藏要推出的vc的底部bar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}@end
