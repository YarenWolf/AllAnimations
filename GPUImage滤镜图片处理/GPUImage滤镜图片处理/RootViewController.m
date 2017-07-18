//
//  RootViewController.m
//  GPUImage滤镜图片处理
//
//  Created by yang on 4/5/14.
//  Copyright (c) 2014 北京千锋互联科技有限公司. All rights reserved.
//

#import "RootViewController.h"
// 黑白处理的滤镜
#import "GrayscaleContrastFilter.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"滤镜处理";
    
    // 1. 创建一个最后滤镜图片显示的区域view
    CGRect rect = CGRectMake(10, 70, 300, 300);
    imageView = [[GPUImageView alloc] initWithFrame:rect];
    [self.view addSubview:imageView];
    
    
    // 2. 创建GPUImage可以处理图片元素
    UIImage *img = [UIImage imageNamed:@"fbbbl_01.jpg"];
    // GPUImagePicture相当于 GPUImage 里面的 UIImage
    // GPUImage里面只认识 GPUImagePicture不认识UIImage
    imagePicture = [[GPUImagePicture alloc] initWithImage:img smoothlyScaleOutput:YES];
    /* UIImage+UIImageView | CCSprite | GPUImagePicuture+GPUImageView */
    
    
    // 3. 创建滤镜
    filterIndex = 1;
    [self processFilterWithIndex:filterIndex];

    // 创建10个按钮
    for (int i = 0; i < 10; i++) {
        CGFloat width = 30;
        CGFloat x = i*width;
        CGFloat y = 400;
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        b.frame = CGRectMake(x, y, width, 50);
        b.tag = i+1;
        NSString *str = [NSString stringWithFormat:@"%d", b.tag];
        [b setTitle:str forState:UIControlStateNormal];
        [b addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:b];
    }
    UIButton *blackWriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    blackWriteButton.frame = CGRectMake(10, 430, 80, 50);
    [blackWriteButton setTitle:@"黑白" forState:UIControlStateNormal];
    [blackWriteButton addTarget:self action:@selector(clickBlackWrite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blackWriteButton];
}
- (void) clickBlackWrite:(UIButton *)arg {
    // 把之前滤镜里面的内容全部删除
    [self removeAllTargets];
    // 创建一个黑白的滤镜
    filter = [[GrayscaleContrastFilter alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
    ^{
        // 在从线程中做
        [self processFilter];
    });
}
- (void) buttonClick:(UIButton *)arg {
    filterIndex = arg.tag;
    // 开始处理第几个滤镜...
    
    [self removeAllTargets];
    
    [self processFilterWithIndex:filterIndex];
}
- (void) processFilterWithIndex:(NSInteger)index {
    NSString *filterName = [NSString stringWithFormat:@"%02u", index];
    // 01
    // GPUImageToneCurveFilter以01.acv文件创建一个滤镜对象
    filter = [[GPUImageToneCurveFilter alloc] initWithACV:filterName];
    // 图片滤镜处理/Matrix/黑客帝国 太耗费cpu了 好耗时间了, 所以我们需要把滤镜处理放在一个线程中去做
    /* 下面这段代码相当于 [NSThread detachXXXX:self selector:@selector(processFilter)];
     */
    // 系统的一个存在的全局 队列 NSOperationQueue
    // dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
    ^void(void){
        // 在从线程中做 这个函数会消耗很多cpu
        [self processFilter];
    });
}
- (void) removeAllTargets {
    [imagePicture removeAllTargets];
    [filter removeAllTargets];
}
// 这个函数会消耗很多cpu
- (void) processFilter {
    // 关联imageFicture输出到filter中
    [imagePicture addTarget:filter];
    // 关联filter输出到imageView上
    [filter addTarget:imageView];
    
    // 上面2句话的意思是: imagePicture--->filter--->imageView
    // imagePicture--->filter--->filter2--->filter3--->imageView
    // 开始处理滤镜
    [imagePicture processImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
