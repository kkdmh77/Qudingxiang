//
//  LrdOutputView.m
//  LrdOutputView
//
//  Created by 键盘上的舞者 on 4/14/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "LrdOutputView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CellLineEdgeInsets UIEdgeInsetsMake(0, 10, 0, 10)
#define LeftToView 10.f
#define TopToView 10.f

@interface LrdOutputView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) LrdOutputViewDirection direction;

@end

@implementation LrdOutputView

- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(LrdOutputViewDirection)direction {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        
        
        //背景色为clearColor
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        
        self.origin = origin;
        self.height = height;
        self.width = width;
        self.direction = direction;
        self.dataArray = dataArray;
        if (height <= 0) {
            height = 44;
        }
        if (direction == kLrdOutputViewDirectionLeft) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, height * _dataArray.count) style:UITableViewStylePlain];
        }else if (direction == kLrdOutputViewDirectionRight){
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, -width, height * _dataArray.count) style:UITableViewStylePlain];
        }else{
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, origin.y, width, -height * _dataArray.count) style:UITableViewStylePlain];
            self.backgroundColor = [UIColor clearColor];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
//        _tableView.separatorColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        _tableView.layer.cornerRadius = 2;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //注册cell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [self addSubview:self.tableView];
        
        //cell线条
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:CellLineEdgeInsets];
        }
            
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:CellLineEdgeInsets];
        }

    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (self.direction == kLrdOutputViewDirectionTop) {
    
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FitRealValue(200), FitRealValue(170))];
        lineView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:lineView];
        
        LrdCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
        UIImageView *mapImage = [[UIImageView alloc] initWithFrame:CGRectMake(FitRealValue(20), FitRealValue(20), FitRealValue(160), FitRealValue(100))];
        mapImage.image = [UIImage imageNamed:model.imageName];
        [lineView addSubview:mapImage];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:mapImage.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(2, 2)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = mapImage.bounds;
        maskLayer.path = maskPath.CGPath;
        mapImage.layer.mask = maskLayer;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(FitRealValue(20), FitRealValue(120), FitRealValue(160), FitRealValue(40))];
        bgView.backgroundColor = [UIColor whiteColor];
        [lineView addSubview:bgView];
        
        UIBezierPath *maskbgViewPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
        CAShapeLayer *maskbgViewLayer = [[CAShapeLayer alloc] init];
        maskbgViewLayer.frame = bgView.bounds;
        maskbgViewLayer.path = maskbgViewPath.CGPath;
        bgView.layer.mask = maskbgViewLayer;
        
        UILabel *mapTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FitRealValue(160), FitRealValue(40))];
        mapTitle.text = model.title;
        mapTitle.textColor = QDXGray;
        mapTitle.textAlignment = NSTextAlignmentCenter;
        mapTitle.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:mapTitle];
        
    }else{
        cell.textLabel.textColor = [UIColor colorWithWhite:0.067 alpha:1.000];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        
        //    UIView *cellLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
        //    cellLine.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        //    [cell addSubview:cellLine];
        //取出模型
        LrdCellModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.title;
        cell.imageView.image = [UIImage imageNamed:model.imageName];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //通知代理处理点击事件
    if ([self.delegate respondsToSelector:@selector(didSelectedAtIndexPath:)]) {
        [self.delegate didSelectedAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:CellLineEdgeInsets];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:CellLineEdgeInsets];
    }
}

//画出尖尖
- (void)drawRect:(CGRect)rect {
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    
    if (self.direction == kLrdOutputViewDirectionLeft) {
        CGFloat startX = self.origin.x + 20;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        
        CGContextAddLineToPoint(context, startX + 10, startY);
    }else if (self.direction == kLrdOutputViewDirectionRight) {
        CGFloat startX = self.origin.x - 20;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        
        CGContextAddLineToPoint(context, startX + 5, startY - 5);
        
        CGContextAddLineToPoint(context, startX + 10, startY);
    }else {
        CGFloat startX = self.origin.x + self.width/2 - 5;
        CGFloat startY = self.origin.y;
        CGContextMoveToPoint(context, startX, startY);//设置起点
        
        CGContextAddLineToPoint(context, startX + 5, startY + 5);
        
        CGContextAddLineToPoint(context, startX + 10, startY);
    }
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [self.tableView.backgroundColor setFill]; //设置填充色
    
    
    [self.tableView.backgroundColor setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    

}

- (void)pop {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    if (self.direction == kLrdOutputViewDirectionTop){
        self.alpha = 0;
        CGRect frame = self.tableView.frame;
        self.tableView.frame = CGRectMake(self.origin.x + self.width/2 - 5, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.tableView.frame = frame;
        }];
    }else{
        //动画效果弹出
        self.alpha = 0;
        CGRect frame = self.tableView.frame;
        self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
            self.tableView.frame = frame;
        }];
    }
}

- (void)dismiss {
    
    if (self.direction == kLrdOutputViewDirectionTop){
        //动画效果淡出
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
            self.tableView.frame = CGRectMake(self.origin.x + self.width/2 - 5, self.origin.y, 0, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                if (self.dismissOperation) {
                    self.dismissOperation();
                }
            }
        }];
    }else{
        //动画效果淡出
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
            self.tableView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                if (self.dismissOperation) {
                    self.dismissOperation();
                }
            }
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView]) {
        [self dismiss];
    }
}

@end


#pragma mark - LrdCellModel

@implementation LrdCellModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    LrdCellModel *model = [[LrdCellModel alloc] init];
    model.title = title;
    model.imageName = imageName;
    return model;
}

@end
