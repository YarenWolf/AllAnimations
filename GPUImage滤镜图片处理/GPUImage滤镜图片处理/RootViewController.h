//
//  RootViewController.h
//  GPUImage滤镜图片处理
//
//  Created by yang on 4/5/14.
//  Copyright (c) 2014 北京千锋互联科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface RootViewController : UIViewController
{
    // 滤镜最后输出的view
    GPUImageView *imageView;
    //
    GPUImagePicture *imagePicture;
    
    // 滤镜编号
    NSUInteger filterIndex;
    
    // 创建滤镜 某个一个特定的滤镜  Filter过滤/滤波
    GPUImageFilter *filter;
}
@end
