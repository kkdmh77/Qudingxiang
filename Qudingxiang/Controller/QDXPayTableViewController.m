//
//  QDXPayTableViewController.m
//  趣定向
//
//  Created by Air on 16/1/18.
//  Copyright © 2016年 Air. All rights reserved.
//

#import "QDXPayTableViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import "APAuthV2Info.h"
#import "QDXOrdermodel.h"
#import "AlipayModel.h"
#import "WeixinModel.h"
#import "QDXTicketInfoModel.h"
#import "QDXOrderDetailTableViewController.h"
#import "AppDelegate.h"
#import "Orders.h"

@interface QDXPayTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *pay;
    UIImageView *Aliselect;
    UIImageView *WXselect;
    int aliOrWX;
}
@property (nonatomic, strong) AlipayModel *Alipay;
@property (nonatomic, strong) WeixinModel *WXpay;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation QDXPayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单支付";

    [self createTableView];
    aliOrWX = 2;
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.WXPayBlock = ^(){
        QDXOrderDetailTableViewController* QDetailVC=[[QDXOrderDetailTableViewController alloc]init];
        QDetailVC.orders= self.Order;
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay" object:nil];
    };
}

-(void)createTableView
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, FitRealValue(20), QdxWidth, FitRealValue(580)) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.backgroundColor = QDXBGColor;
    self.tableview.scrollEnabled = NO;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableview];
    
    pay = [[UIButton alloc] initWithFrame:CGRectMake(FitRealValue(24), FitRealValue(580), QdxWidth - FitRealValue(24 + 24), FitRealValue(80))];
    [pay setTitle:@"确认支付" forState:UIControlStateNormal];
    pay.userInteractionEnabled = NO;
    [pay setBackgroundImage:[ToolView createImageWithColor:QDXLightGray] forState:UIControlStateNormal];
    [pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pay setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [pay addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pay];
    
}
-(void)pay
{
    if (aliOrWX == 1) {
        [self AlipayClicked];
        pay.userInteractionEnabled = YES;
    }else if(aliOrWX == 0){
        [self WXClicked];
        pay.userInteractionEnabled = YES;
    }else{
        [MBProgressHUD showError:@"请选择支付方式!"];
    }
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1&&indexPath.row == 0) {
        cell.textLabel.text = @"微信支付";
        cell.imageView.image = [UIImage imageNamed:@"微信支付"];
        WXselect = [[UIImageView alloc] initWithFrame:CGRectMake(QdxWidth - FitRealValue(24 + 43), FitRealValue(48), FitRealValue(43), FitRealValue(43))];
        WXselect.image = [UIImage imageNamed:@"勾选默认"];
        [cell addSubview:WXselect];
    }else if (indexPath.section == 1&&indexPath.row == 1){
        cell.textLabel.text = @"支付宝支付";
        cell.imageView.image = [UIImage imageNamed:@"支付宝支付"];
        Aliselect = [[UIImageView alloc] initWithFrame:CGRectMake(QdxWidth - FitRealValue(24 + 43), FitRealValue(48), FitRealValue(43), FitRealValue(43))];
        Aliselect.image = [UIImage imageNamed:@"勾选默认"];
        [cell addSubview:Aliselect];
    }else if (indexPath.section == 0&&indexPath.row == 0){
        cell.textLabel.text = @"总额";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = QDXGray;
        UILabel *cost = [[UILabel alloc] initWithFrame:CGRectMake(QdxWidth/2 - FitRealValue(24), 0, QdxWidth/2, FitRealValue(100))];
        cost.textColor = QDXOrange;
        cost.textAlignment = NSTextAlignmentRight;
        cost.font = [UIFont systemFontOfSize:20];
        cost.text =[@"¥" stringByAppendingString: self.Order.orders_account];
        [cell addSubview:cost];
        cell.backgroundColor = [UIColor colorWithRed:0.996 green:0.957 blue:0.800 alpha:1.000];
    }
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return FitRealValue(100);
    }else{
        return FitRealValue(140);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = FitRealValue(60);
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QdxWidth, FitRealValue(100))];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(FitRealValue(24), 0, QdxWidth *  0.7 , FitRealValue(100))];
        header.text = @"选择支付方式";
        header.textColor = QDXBlack;
        header.font = [UIFont fontWithName:@"Arial" size:17];
        header.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:header];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(FitRealValue(24), FitRealValue(100), QdxWidth - FitRealValue(24 + 24), 0.5)];
        lineView.backgroundColor = QDXLineColor;
        [headerView addSubview:lineView];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return FitRealValue(20);
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return FitRealValue(80 + 20);
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0,FitRealValue(24), 0,FitRealValue(24))];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0,FitRealValue(24), 0, FitRealValue(24))];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0,0, 0,0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0,0, 0,0)];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1&&indexPath.row==0) {
        WXselect.image = [UIImage imageNamed:@"勾选选中"];
        Aliselect.image = [UIImage imageNamed:@"勾选默认"];
        aliOrWX = 0;
        
        pay.userInteractionEnabled = NO;
        [pay setBackgroundImage:[ToolView createImageWithColor:QDXLightGray] forState:UIControlStateNormal];
        
        [self getWeixinpay];
    }else if (indexPath.section == 1&&indexPath.row==1){
        Aliselect.image = [UIImage imageNamed:@"勾选选中"];
        WXselect.image = [UIImage imageNamed:@"勾选默认"];
        aliOrWX = 1;
        
        pay.userInteractionEnabled = NO;
        [pay setBackgroundImage:[ToolView createImageWithColor:QDXLightGray] forState:UIControlStateNormal];
        
        [self getAlipayapp];
    }
}

-(void)getAlipayapp{
    NSString *url = [newHostUrl stringByAppendingString:alipayPayUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"customer_token"] = save;
    params[@"orders_id"] = self.Order.orders_id;
    [PPNetworkHelper POST:url parameters:params success:^(id responseObject) {
        
        _Alipay = [AlipayModel mj_objectWithKeyValues:responseObject];
        pay.userInteractionEnabled = YES;
        CGFloat top = 25;
        CGFloat bottom = 25;
        CGFloat left = 5;
        CGFloat right = 5;
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        [pay setBackgroundImage:[[UIImage imageNamed:@"sign_button"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        
    }];
}

-(void)getWeixinpay{
    NSString *url = [newHostUrl stringByAppendingString:weixinPayUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"customer_token"] = save;
    params[@"orders_id"] = self.Order.orders_id;
    [PPNetworkHelper POST:url parameters:params success:^(id responseObject) {
            
        _WXpay = [WeixinModel mj_objectWithKeyValues:responseObject];
        pay.userInteractionEnabled = YES;
        CGFloat top = 25;
        CGFloat bottom = 25;
        CGFloat left = 5;
        CGFloat right = 5;
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        [pay setBackgroundImage:[[UIImage imageNamed:@"sign_button"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)WXClicked
{
    [MBProgressHUD showMessage:@"正在处理"];
                NSString *stamp  = _WXpay.timestamp;
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = _WXpay.partnerid;
                req.prepayId            = _WXpay.prepayid;
                req.nonceStr            = _WXpay.noncestr;
                req.timeStamp           = [stamp intValue];
                req.package             = _WXpay.package;
                req.sign                = _WXpay.sign;
                [WXApi sendReq:req];
    [MBProgressHUD hideHUD];
}

#pragma mark
-(void)AlipayClicked
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [self.productList alloc];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *partner = _Alipay.partner;
    NSString *seller = _Alipay.seller;
    NSString *privateKey =_Alipay.privateKey;
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"缺少partner或者seller或者私钥。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = self.Order.orders_cn; //订单ID（由商家自行制定）
    order.productName = self.Order.goods_cn; //商品标题
    order.productDescription = self.Order.goods_cn; //商品描述
    order.amount = self.Order.orders_account; //商品价格
    order.notifyURL =  _Alipay.notify; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipay2088121109128595";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *message = @"";
            switch([[resultDic objectForKey:@"resultStatus"] integerValue])
            {
                case 9000:message = @"订单支付成功";
                    break;
                case 8000:message = @"正在处理中";break;
                case 4000:message = @"订单支付失败";break;
                case 6001:message = @"用户中途取消";break;
                case 6002:message = @"网络连接错误";break;
                default:message = @"未知错误";
            }
            UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
                QDXOrderDetailTableViewController* QDetailVC=[[QDXOrderDetailTableViewController alloc]init];
                QDetailVC.orders = self.Order;
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pay" object:nil];
            }]];
            [self presentViewController:aalert animated:YES completion:nil];
            

        }];
    }

}

@end
