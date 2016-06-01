//
//  CYAlertView.h
//  CYAlertView
//
//  Created by Cyrus on 16/4/13.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYAlertAction;

@interface CYAlertView : UIView

/** 保存当前的视图控制器，用来dismiss */
@property (nonatomic, weak, nullable)UIViewController *controller;

/**
 *    初始化 AlertView
 *
 *    @param title   标题
 *    @param message 消息
 */
- (_Nonnull instancetype)initWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message;

- (_Nonnull instancetype)initWithOffLineTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message;

/**
 *    添加一个 action
 *
 *    @param action action
 */
- (void)addAction:(CYAlertAction * _Nonnull)action;

@end
