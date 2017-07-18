//
//  ViewController.m
//  视图整合练习
#import "ViewController.h"
#import "LeftView.h"
#import "MyView.h"
#import "SecondViewController.h"
@interface ViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView *imageViewAnimation;
@property (strong, nonatomic) UISlider *slider;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    MyView *myView = [[MyView alloc]initWithFrame:self.view.bounds];
    self.slider  = [[UISlider alloc]initWithFrame:CGRectMake(200, 200, 300, 5)];
    [self.view addSubview:myView];
    [_slider addTarget:self action:@selector(setNeedsDisplay) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    //获取view的layer对象=======================================
    UIImageView *grayView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    CALayer *layer=grayView.layer;
    //2.设置背景色
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.borderColor=[UIColor yellowColor].CGColor;
    layer.borderWidth=3;
    layer.cornerRadius=30;
    layer.shadowColor=[UIColor greenColor].CGColor;
    layer.shadowOpacity=1;//透明度
    layer.shadowOffset=CGSizeMake(10, 20);
    layer.shadowRadius=50;
    [self.view addSubview:grayView];
    //图片=================================================
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 120, 200, 100)];
    imageView.image=[UIImage imageNamed:@"image (7).jpg"];
    imageView.layer.cornerRadius=50;
    imageView.layer.masksToBounds=YES;//沿着剪掉外面的内容
    imageView.layer.borderColor=[UIColor greenColor].CGColor;
    imageView.layer.borderWidth=5;
    //CALayer具有容器的特性，可以相互嵌套。
    //创建一个只有文字的新层===============================
    CATextLayer *nameLayer=[CATextLayer layer];
    NSString *str=@"薛超";
    nameLayer.string=str;
    nameLayer.foregroundColor=[UIColor blueColor].CGColor;
    nameLayer.frame=CGRectMake(100, 50, 100, 50);
    [imageView.layer addSublayer:nameLayer];
    [self.view addSubview:imageView];
    //创建一个有图片内容的新层============================
    CALayer *imageLayer=[CALayer layer];
    imageLayer.contents=(id)[UIImage imageNamed:@"image (2).jpg"].CGImage;
    imageLayer.frame=CGRectMake(0, 250, 200, 100);
    imageLayer.cornerRadius=30;
    imageLayer.masksToBounds=YES;
    [self.view.layer addSublayer:imageLayer];
    imageLayer.transform=CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    //UIImage动画=================================
    self.imageViewAnimation=[[UIImageView alloc]initWithFrame:CGRectMake(20, 380, 150, 300)];
    self.imageViewAnimation.image=[UIImage animatedImageNamed:@"knockout_7" duration:2];
    [self.view addSubview:self.imageViewAnimation];
    //UIImageView动画=================================
    UIButton *imageButton=[[UIButton alloc]initWithFrame:self.imageViewAnimation.frame];
    [imageButton addTarget:self action:@selector(clickOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageButton];
    //========================通过左边手势引出左边视图
    UISwipeGestureRecognizer *swip=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gotoOtherView:)];
    swip.direction=UISwipeGestureRecognizerDirectionRight;
    self.view.userInteractionEnabled=YES;//用户交互
    swip.delegate=self;
    [self.view addGestureRecognizer:swip];
    //双击触发UIView动画============
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMyUIViewAnimation)];
    tap.numberOfTapsRequired=2;
    [self.view addGestureRecognizer:tap];
    //NSTimer计时器
    //NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(doSomething:) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //销毁定时器[timer invalidate];
    //创建同时就启动timer的方法
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(doSomething:) userInfo:nil repeats:YES];
    
}
-(void)showMyUIViewAnimation{
    //UIView动画============================
    UIImageView *ima=[[UIImageView alloc]initWithFrame:self.view.frame];
    ima.image=[UIImage imageNamed:@"image (10).jpg"];
    [self.view addSubview:ima];
    [UIView animateWithDuration:5 animations:^{
        ima.alpha=0.5;
        ima.frame=CGRectMake(200, 300, 0, 0);
    }];
}
//点击头部触发动画
- (void)clickOut{
    //先构建存储了动画需要的图片的图片数组
    NSMutableArray *allImage=[NSMutableArray array];
    //循环向数组中添加UIImage图片
    for(NSInteger i=0;i<=80;i++){
        //格式化图片名称
        NSString *imageName=[NSString stringWithFormat:@"knockout_%02ld.jpg",i];
        //构建带有目录信息的地址字符串
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path=[bundle pathForResource:imageName ofType:nil];
        //imageWithContentsOfFile方法只会在创建时加载image引用消失后，图片从内存中释放，参数file必须写图片的完整路径。
        UIImage *myImage=[UIImage imageWithContentsOfFile:path];
        [allImage addObject:myImage];
    }
    //设置动画数组
    self.imageViewAnimation.animationImages=allImage;
    //设置重复次数
    self.imageViewAnimation.animationRepeatCount=1;
    //设置动画时长
    self.imageViewAnimation.animationDuration=80*1/12.0;
    [self.view addSubview:self.imageViewAnimation];
    [self.imageViewAnimation startAnimating];
    //动画结束后主动将imageView的animationImages属性赋值nil
    [self.imageViewAnimation performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.imageViewAnimation.animationDuration];
}
-(void)gotoOtherView:(UIGestureRecognizer*)sender{
    switch ([(UISwipeGestureRecognizer*)sender direction]){
        case UISwipeGestureRecognizerDirectionRight:{
    //=========================跳出左边视图
    LeftView *lView=[[LeftView alloc]initWithFrame:CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:lView];
    //在内存中临时申请一块画布.opaque:YES代表不透明  NO代表透明
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 300),NO, 2);
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 250)];
    [path addClip];
    UIImageView *MyimageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 230)];
    UIImage *image=[UIImage imageNamed:@"image (10).jpg"];
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    //将画布中的图像另存成一个image对象
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    MyimageView.image=newImage;
    UIGraphicsEndImageContext();
    [lView addSubview:MyimageView];
    //以上是一段特殊的空间，可以进行绘制
            [UIView animateWithDuration:1 animations:^{
                lView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            }];
        break;
    }
        case UISwipeGestureRecognizerDirectionLeft:{
            SecondViewController *svc=[[SecondViewController alloc]init];
            [self presentViewController:svc animated:YES completion:nil];
        break;
        }
            
        default:break;
    }
}
@end
