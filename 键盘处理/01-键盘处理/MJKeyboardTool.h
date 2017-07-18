//
//  MJKeyboardTool.h
//  05-键盘处理
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKeyboardTool;

typedef enum {
    MJKeyboardToolItemTypePrevious, // 上一个
    MJKeyboardToolItemTypeNext, // 下一个
    MJKeyboardToolItemTypeDone // 完成
} MJKeyboardToolItemType;

@protocol MJKeyboardToolDelegate <NSObject>
@optional
//- (void)keyboardToolPreviousClick:(MJKeyboardTool *)keyboardTool;
//- (void)keyboardToolNextClick:(MJKeyboardTool *)keyboardTool;
//- (void)keyboardToolDoneClick:(MJKeyboardTool *)keyboardTool;
- (void)keyboardTool:(MJKeyboardTool *)keyboardTool itemClick:(MJKeyboardToolItemType)itemType;
@end

@interface MJKeyboardTool : UIView
- (IBAction)previous; // 上一个
- (IBAction)next; // 下一个
- (IBAction)done; // 完成
@property (weak, nonatomic, readonly) IBOutlet UIBarButtonItem *previousItem;
@property (weak, nonatomic, readonly) IBOutlet UIBarButtonItem *nextItem;

@property (nonatomic, weak) id<MJKeyboardToolDelegate> delegate;

+ (id)keyboardTool;
@end
