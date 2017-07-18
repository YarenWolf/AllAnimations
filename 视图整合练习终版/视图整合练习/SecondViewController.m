//
//  SecondViewController.m
//  视图整合练习
//
//  Created by ISD1510 on 16/1/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView *imageView;
//@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic)BOOL play;
//添加一个一秒钟相应60次的定时器。
@property(nonatomic,strong)CADisplayLink *link;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.image=[UIImage imageNamed:@"image (19).jpg"];
    [self.view addSubview:self.imageView];
    self.button1=[[UIButton alloc]init];
    self.button1.backgroundColor=[UIColor redColor];
    self.button2=[[UIButton alloc]init];
    self.button2.backgroundColor=[UIColor greenColor];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self LayoutMyViewByMation];
    //[self LayoutMyViewByVFL];
    //[self LayoutMyViewByAutoresizing];
    //[self CoreAnimation];//添加旋转动画
    //[self creatMyGestural];
    //[self position];
    //[self transform];
    //[self keyFramAnimation];
}
-(void)creatMyGestural{
    //1.创建点击手势
    UITapGestureRecognizer *tabGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tabGR.numberOfTapsRequired=2;
    tabGR.numberOfTouchesRequired=1;//几个手指
    [self.view addGestureRecognizer:tabGR];
    //2.轻扫手势
    UISwipeGestureRecognizer *swip=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    swip.direction=UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    //3.长按手势
    UILongPressGestureRecognizer *longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressdid:)];
    longpress.minimumPressDuration=2;
    [self.view addGestureRecognizer:longpress];
    //4.捏合手势
    UIPinchGestureRecognizer *niehe=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(niehe:)];
    [self.view addGestureRecognizer:niehe];
    //5.拖拽手势
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    //6.旋转手势
    UIRotationGestureRecognizer *rotation=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    [self.view addGestureRecognizer:rotation];
    tabGR.delegate=self;
    swip.delegate=self;
    longpress.delegate=self;
    niehe.delegate=self;
    pan.delegate=self;
    rotation.delegate=self;
}
-(void)pan:(UIPanGestureRecognizer*)sender{
    //CGPoint location=[sender locationInView:self.view];
    CGPoint translation=[sender translationInView:self.imageView];
    //self.imageView.transform = CGAffineTransformMakeTranslation(20, 20);
    self.imageView.transform=CGAffineTransformTranslate(self.imageView.transform,translation.x,translation.y);
    //将本次走了的距离归零
    [sender setTranslation:CGPointZero inView:self.view];
    //修改中心点实现位移
}
-(void)niehe:(UIPinchGestureRecognizer*)sender{
    //代表动作快慢的速率值,如果是正数则是想歪扩展，负数代表向内捏合。绝对值代表速率
    CGFloat velocity= sender.velocity;
    NSLog(@"%f",velocity);
      //self.imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.imageView.transform=CGAffineTransformScale(self.imageView.transform, sender.scale, sender.scale);
    [sender setScale:1];
}
-(void)rotation:(UIRotationGestureRecognizer*)sender{
    //self.imageView.transform = CGAffineTransformMakeRotation(M_PI_4);
    self.imageView.transform=CGAffineTransformRotate(self.imageView.transform, sender.rotation);
    [sender setRotation:0];
}
-(void)longpressdid:(UILongPressGestureRecognizer*)sender{
    NSLog(@"%@",NSStringFromCGPoint([sender locationInView:self.view]));
}
-(void)tap:(UITapGestureRecognizer*)sender{
    //获得触点的位置
    //CGPoint point= [sender locationInView:self.view];
    //identity是系统提供的一个常量，记录的就是没有发生任何变形时的那个矩阵
    self.imageView.transform=CGAffineTransformIdentity;
}
#pragma mark 来自协议
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
#pragma mark 动画
-(CADisplayLink *)link{
    if(!_link){
        _link=[CADisplayLink displayLinkWithTarget:self selector:@selector(rotation)];
        //手动将定时器添加到事件循环中
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }return _link;
}
//此方法每秒钟调用60次
-(void)rotation{
    self.imageView.layer.transform=CATransform3DRotate(self.imageView.layer.transform, M_PI_4/10, 0, 1, 1);
}
//启动或暂停旋转动作
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.play=!self.play;
    self.link.paused=self.play;
}
-(void)CoreAnimation{
    self.play=NO;
    //变圆形
    self.imageView.layer.cornerRadius=100;
    self.imageView.layer.masksToBounds=YES;
    self.imageView.layer.position=CGPointMake(200, 300);
    self.imageView.layer.anchorPoint=CGPointMake(0.3, -0.3);
}
#pragma mark 其它动画
-(void)position{
    //创建基础动画=============================慢慢移动到指定位置然后返回
    CABasicAnimation *anim=[CABasicAnimation animation];
    //一个重要的设置：设置动画要修改的内容。
    //路径 position   大小：scale  旋转：rotation   使用kvc的方式对对象的属性进行赋值。
    anim.keyPath=@"position";
    //设置动画的起始值和结束值,此处给的一定是对象类型，所以要使用nsvalue对数据进行包装。
    //anim.fromValue;
    anim.toValue=[NSValue valueWithCGPoint:CGPointMake(200, 500)];
    //动画时长
    anim.duration=2;
    //动画的重复次数
    anim.repeatCount=3;
    //添加动画到指定位置上
    [self.imageView.layer addAnimation:anim forKey:nil];
    anim.removedOnCompletion=NO;
    anim.fillMode=kCAFillModeBackwards;//不会回到原来的位置。
}
//测试与变形有关的动画效果======================放大缩小与旋转
-(void)transform{
    CABasicAnimation *anim=[CABasicAnimation animation];
    anim.keyPath=@"transform";
    anim.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.9, 1)];
    anim.duration=0.5;anim.repeatCount=MAXFLOAT;
    [self.imageView.layer addAnimation:anim forKey:nil];
    //anim.key=@"alph";
    //anim.keyPath=@"opacity";
    //anim.keyPath=@"transform3D.scale";
    //anim.toValue=@2;
    //anim.duration=@1；
    anim.keyPath=@"transform.rotation";
    anim.toValue=@(2*M_PI);
    anim.duration=1;
    anim.repeatCount=5;
    [self.imageView.layer addAnimation:anim forKey:nil];
}
//测试关键帧动画===============================沿着路径行进
-(void)keyFramAnimation{
    CAKeyframeAnimation *anim=[CAKeyframeAnimation animation];
    //设置要修改的那个属性
    anim.keyPath=@"position";
    //设置具体的行进路线
    anim.path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 100, 600, 400)].CGPath;
    anim.duration=2;
    anim.repeatCount=MAXFLOAT;
    [self.imageView.layer addAnimation:anim forKey:nil];
}
#pragma mark 自动布局
//自动布局===================================================================================
-(void)viewDidLayoutSubviews{
    self.button1.frame=CGRectMake(self.view.frame.origin.x+20, self.view.frame.origin.y+20,(self.view.bounds.size.width-60)/2, 50);
    self.button2.frame=CGRectMake(self.button1.frame.origin.x+self.button1.bounds.size.width+20, self.view.frame.origin.y+20,self.button1.bounds.size.width, 50);
}
//VFL法自动布局============================
-(void)LayoutMyViewByVFL{
    self.button1.translatesAutoresizingMaskIntoConstraints = NO;
    self.button2.translatesAutoresizingMaskIntoConstraints = NO;
     //1.创建尺寸对照表
    NSDictionary *metrics = @{@"left":@20,@"right":@20,@"spacing":@50};
    //创建视图对照表//此函数就自动将传入的对象名字符串做key//将此对象做该key的value，生成如下形式的字典//{@"b1":b1,@"b2":b2}
    NSDictionary  *dictionary =NSDictionaryOfVariableBindings(_button1,_button2);
    //1.创建水平方向的约束描述
    NSString *hVFL = @"|-left-[_button1]-spacing-[_button2(_button1)]-right-|";
    //2.将VFL变成一组约束.options参数：对齐方式。
    NSArray *cs1 = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:metrics views:dictionary];
    // 创建竖直方向的VFL
    NSString *vVFL = @"V:|-40-[_button1(30)]";
    NSArray *cs2 = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:metrics views:dictionary];
    [self.view addConstraints:cs1];
    [self.view addConstraints:cs2];
}
//用AutoResizing布局==========================
-(void)LayoutMyViewByAutoresizing{
    //创建按钮
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor redColor];
    label.frame = CGRectMake(20, self.view.bounds.size.height-40, 100, 20);
    //点亮红线//与在第5个检查器中设置相反//如：左和下想固定，则需要设置上和右为可变
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:label];
}
//万能公式自动布局==========================
-(void)LayoutMyViewByMation{
    //1.关闭button1和button2的自动翻译红线为约束功能
    //button1.translatesAutoresizingMaskIntoConstraints=NO;
    //button2.translatesAutoresizingMaskIntoConstraints=NO;
    //2.创建约束
    //button1.left=view.left*1+20;
    //button1.top=self.view.top+20;
    //button1.right=button2.left*1-10;
    //button1.width=button2.width;
    //button1.height=nil.notanattri+100;
    //button2.right=view.right-20;
    //button2.top=button1.top+0;
    //button2.height=button1.height;
    //NSLayoutConstraint *c1=[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    //NSLayoutConstraint *c2=[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    //NSLayoutConstraint *c3=[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:button2 attribute:NSLayoutAttributeLeft multiplier:1 constant:-10];
    //NSLayoutConstraint *c4=[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button2 attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    //NSLayoutConstraint *c5=[NSLayoutConstraint constraintWithItem:button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    //NSLayoutConstraint *d1=[NSLayoutConstraint constraintWithItem:button2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
    //NSLayoutConstraint *d2=[NSLayoutConstraint constraintWithItem:button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button1 attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    //NSLayoutConstraint *d3=[NSLayoutConstraint constraintWithItem:button2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:button1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    //[self.view addConstraints:@[c1,c2,c3,c4,c5,d1,d2,d3]];
}
@end
