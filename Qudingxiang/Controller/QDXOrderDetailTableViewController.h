//
//  QDXOrderDetailTableViewController.h
//  趣定向
//
//  Created by Air on 16/1/22.
//  Copyright © 2016年 Air. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDXStateView.h"

@class Orders;
@interface QDXOrderDetailTableViewController : BaseViewController<StateDelegate>
@property(nonatomic,retain) Orders *orders;
@end
