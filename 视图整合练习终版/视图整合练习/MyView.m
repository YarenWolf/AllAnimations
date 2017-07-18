//
//  MyView.m
//  视图整合练习
//
//  Created by ISD1510 on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MyView.h"
@interface MyView()
@property(nonatomic,strong)NSMutableArray *pathes;
@property(nonatomic,strong)UIBezierPath *path;
@property(nonatomic,assign)CGPoint point;
@property(nonatomic)BOOL isRect;
@end
@implementation MyView
- (void)SliderValueChanged:(UISlider *)sender {
    [self setNeedsDisplay];
}

//绘画功能=============================================
-(UIBezierPath *)path{
    if(!_path){
        _path=[UIBezierPath new];
    }
    return _path;
}
- (void)drawRect:(CGRect)rect {
    //self.path=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(60, 60, 100, 200) cornerRadius:20];
    [[UIColor redColor]setStroke];
    self.path.lineWidth=3;
    [self.path stroke];
    [self.path fill];
    //绘制矩形===========================从最下面的方法重绘调用
    for (MyView *brush in self.pathes) {
        brush.path.lineWidth=3;
        [brush.path stroke];
    }
    //=====================================三角形
    //获取绘图上下文对象
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 210, 22);
    CGContextAddLineToPoint(context, 280, 120);
    CGContextAddLineToPoint(context, 320, 40);
    CGContextAddLineToPoint(context, 210, 22);
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    //第二种方法================边框三角形
    UIBezierPath *spath=[UIBezierPath bezierPath];
    [spath moveToPoint:CGPointMake(210, 150)];
    [spath addLineToPoint:CGPointMake(210, 240)];
    [spath addLineToPoint:CGPointMake(320, 220)];
    [spath closePath];
    [[UIColor redColor]setStroke];
    [[UIColor greenColor]setFill];
    spath.lineWidth=10;
    spath.lineCapStyle =kCGLineCapButt;
    spath.lineJoinStyle=kCGLineJoinRound;
    [spath fill];
    [spath stroke];
    //==============================================
    UIBezierPath *path=[UIBezierPath bezierPath];
     //添加大括号曲线
    [path moveToPoint:CGPointMake(280, 40)];
    [path addCurveToPoint:CGPointMake(240, 180) controlPoint1:CGPointMake(240, 40) controlPoint2:CGPointMake(280, 180)];
    [path addCurveToPoint:CGPointMake(280, 320) controlPoint1:CGPointMake(100, 280) controlPoint2:CGPointMake(240, 320)];
    path.lineWidth=5;
    [[UIColor redColor]setStroke];
    [path stroke];
    //画矩形
    UIBezierPath *newPath=[UIBezierPath bezierPathWithRect:CGRectMake(200, 500, 200, 100)];
    newPath.lineWidth=9;
    [newPath stroke];
    //画圆角矩形
    UIBezierPath *path2=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(250, 500, 100, 100) cornerRadius:20];
    path2.lineWidth=5;
    [path2 stroke];
    //绘制椭圆
    UIBezierPath *path3=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(220, 400, 200, 100)];
    UIBezierPath *path4=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(270, 400, 100, 100)];
    path3.lineWidth=5;
    [path3 stroke];
    [path4 stroke];
    //绘制字符串
    NSString *str=@"Hello World";
    NSDictionary *attribudes=@{
                               NSFontAttributeName:[UIFont systemFontOfSize:18],
                               NSForegroundColorAttributeName:[UIColor redColor],
                               };
    [str drawAtPoint:CGPointMake(220, 50) withAttributes:attribudes];
    //在指定的矩形区域内绘制，到达矩形边缘时，会换行。
    NSString *str1=@"heelllow world i konl't knowa how it feells s to love some body";
    [str1 drawInRect:CGRectMake(220, 330, 150, 100) withAttributes:attribudes];
    NSString *str2=@"就立刻就发生的的就是快乐积分离开的房间阿拉克机覅哦陪我将诶如额外IF奖数据阿飞；近距离的快捷键的发球局；空间来看房时间啊看的数据阿飞看； 大家撒分开来减肥";
    //自动计算画字符串所需的最合适的大小范围。
    CGRect textFrame=[str2 boundingRectWithSize:CGSizeMake(200, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribudes context:nil];
    [str2 drawInRect:CGRectMake(180, 500, textFrame.size.width, textFrame.size.height) withAttributes:attribudes];
    
    //第三种方法画弧==============圆圈
    UIBezierPath *myPath=[[UIBezierPath alloc]init];
    [myPath addArcWithCenter:CGPointMake(300, 350) radius:100 startAngle:0 endAngle:2*M_PI*1 clockwise:YES];
    [myPath addClip];//剪切
    myPath.lineWidth=5;
    [[UIColor greenColor]setStroke];
    [[UIColor redColor]setFill];
    [myPath fill];
    [myPath stroke];
    //=====================叽叽
    UIBezierPath *myPath1=[[UIBezierPath alloc]init];
    [myPath1 addArcWithCenter:CGPointMake(300, 300) radius:20 startAngle:M_PI_2*2 endAngle:M_PI_2*4 clockwise:YES];
    [myPath1 addArcWithCenter:CGPointMake(320, 400) radius:20 startAngle:M_PI_2*2 endAngle:M_PI_2*5 clockwise:YES];
    [myPath1 addArcWithCenter:CGPointMake(260, 400) radius:20 startAngle:M_PI_2*1 endAngle:M_PI_2*4 clockwise:YES];
    [myPath1 closePath];
    myPath1.lineWidth=5;
    [myPath1 stroke];
    

}
//简易画板===============================================
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //将集合中唯一的一个触点对象取出
    UITouch *touch=[touches anyObject];
    //获取触点坐标
    CGPoint point=[touch locationInView:self];
    if (self.isRect) {
        self.point=point;
        MyView *brush=[[MyView alloc]init];
        [self.pathes addObject:brush];
    }else{[self.path moveToPoint:point];}
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //将集合中唯一的一个触点对象取出
    UITouch *touch=[touches anyObject];
    //获取触点坐标
    CGPoint point=[touch locationInView:self];
    
    if(self.isRect){
    MyView *brush=[self.pathes lastObject];
    brush.path=[UIBezierPath bezierPathWithRect:CGRectMake(self.point.x, self.point.y, point.x-self.point.x, point.y-self.point.y)];
    }else{[self.path addLineToPoint:point];}
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isRect=!self.isRect;
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}
#pragma mark 画矩形
-(NSMutableArray*)pathes{
    if (!_pathes) {
        _pathes=[NSMutableArray array];
    }return _pathes;
}
@end
