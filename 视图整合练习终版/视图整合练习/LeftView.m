//
//  LeftView.m
//  视图整合练习
//
//  Created by ISD1510 on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LeftView.h"
#import "Data.h"
@interface LeftView()

@end
@implementation LeftView
- (void)drawRect:(CGRect)rect {
    //===========================绘制气泡框
    NSString *message=@"你好啊美女！今天约吗？你家我家还是如家，今天明天还是七天？";
    NSDictionary *textDictionary=@{
                                   NSFontAttributeName:[UIFont systemFontOfSize:17],
                                   NSForegroundColorAttributeName:[UIColor redColor],
                                   };
    //计算文本的size
    CGSize textOfSize = [message boundingRectWithSize:CGSizeMake(200, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:textDictionary context:nil].size;
    //结算气泡矩形的CGRect
    CGRect popOfRect = CGRectZero;
    popOfRect.origin.x = self.bounds.size.width-30-textOfSize.width;
    popOfRect.origin.y = 20;
    popOfRect.size.width = textOfSize.width+20;
    popOfRect.size.height = textOfSize.height+20;
    //绘制填充的圆角矩形
    UIBezierPath *squalpath = [UIBezierPath bezierPathWithRoundedRect:popOfRect cornerRadius:10];
    [[UIColor grayColor] setFill];
    [squalpath fill];
    //绘制右下角填充的三角形尾巴
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(CGRectGetMaxX(popOfRect) , CGRectGetHeight(popOfRect))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMaxX(popOfRect)+10, CGRectGetHeight(popOfRect)+10)];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMaxX(popOfRect)-10, CGRectGetHeight(popOfRect)+10)];
    [trianglePath closePath];
    [trianglePath fill];
    //绘制字符串
    [message drawInRect:CGRectMake(popOfRect.origin.x+10, 20, textOfSize.width, textOfSize.height) withAttributes:textDictionary];
    //==========================绘制饼图
    CGFloat radius=100;
    NSArray *allPieChartdata= [Data PieChartData];
    CGFloat startA = M_PI_2*3;
    CGFloat endA = 0;
    // 遍历每一个数据，分别绘制圆弧
    for (Data *item in allPieChartdata) {
        endA = startA + item.value*2*M_PI;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(300, 200) radius:radius startAngle:startA  endAngle:endA clockwise:YES];
        //添加到圆心的直线
        [path addLineToPoint:CGPointMake(300, 200)];
        [item.color setFill];
        [path fill];
        //为下一个部分做准备，则开始弧度是上一次的结束弧度
        startA = endA;
    }
    //===============第二张图
    UIImage *myImage=[UIImage imageNamed:@"image (11).jpg"];
    [myImage drawAtPoint:CGPointMake(0,400)];
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 180, 200, 100)];
    [path addClip];//沿着path记录的路径，剪切成路径内的样子。
    [myImage drawInRect:CGRectMake(0, 180, 200, 120)];
    //======================绘制标签
    NSString *str=@"这是美女哦！";
    CGRect textrect=[str boundingRectWithSize:CGSizeMake(110, 99) options:NSStringDrawingUsesLineFragmentOrigin attributes:textDictionary context:nil];
    [str drawInRect:CGRectMake(200-textrect.size.width, 270-textrect.size.height, textrect.size.width, textrect.size.height) withAttributes:textDictionary];
    [self drawQRCode];
}
-(void)drawQRCode{
    //1.创建一个二维码种类的滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.恢复滤镜的默认设置（清除已经设置过的效果）
    [filter setDefaults];
    //3.将隐藏的地址变成二进制数据
    NSData *data=[@"http://www.baidu.com"dataUsingEncoding:NSUTF8StringEncoding];//将字符串变成二进制数据
    //4.通过使用KVC的方式设置滤镜，传入要隐藏的data，滤镜就能够依据data生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    //5.输出二维码图片
    CIImage *outputImage=[filter outputImage];
    //6.将CIImage转换成UIImage
    UIImage *image=[UIImage imageWithCIImage:outputImage];
    //7.显示到图片视图上
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 300, 100, 100)];
    imageView.image=image;
    [self addSubview:imageView];
}
- (void)CoreAnimation {
    //创建绘制图形的层===================================
    CAShapeLayer *shapelayer=[CAShapeLayer layer];
    shapelayer.path=[UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 100, 50)].CGPath;
    shapelayer.strokeColor=[UIColor redColor].CGColor;
    shapelayer.lineWidth=5;
    shapelayer.backgroundColor=[UIColor whiteColor].CGColor;
    shapelayer.frame=CGRectMake(200, 0, 220, 100);
    //添加到父层中
    [self.layer addSublayer:shapelayer];
}
@end
