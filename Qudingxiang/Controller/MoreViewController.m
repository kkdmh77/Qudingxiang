//
//  MoreViewController.m
//  趣定向
//
//  Created by Prince on 16/4/1.
//  Copyright © 2016年 Air. All rights reserved.
//

#import "MoreViewController.h"
#import "QDXNavigationController.h"
#import "QDXLoginViewController.h"
//#import "XDMultTableView.h"
#import "DWViewCell.h"
#import "DWFlowLayout.h"
#import "MCLeftSliderManager.h"

//@interface MoreViewController ()<UIAlertViewDelegate,XDMultTableViewDatasource,XDMultTableViewDelegate>
//@interface MoreViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@interface MoreViewController ()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton *_button;
//    UILabel *rowOne;
//    UILabel *rowTwo;
//    UILabel *rowThree;
    NSArray *data;
}
//@property(nonatomic, readwrite, strong)XDMultTableView *tableView;
//@property(nonatomic, readwrite, strong)UITableView *tableView;
@property(nonatomic, readwrite, strong)UICollectionView *collectionView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"玩法";
    self.view.backgroundColor = QDXBGColor;
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"index_my"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    DWFlowLayout *layout = [[DWFlowLayout alloc] init];
    [layout setPagingEnabled:YES];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, QdxWidth, QdxHeight - 64 - 49) collectionViewLayout:layout];
    [_collectionView registerClass:[DWViewCell class] forCellWithReuseIdentifier:@"DWViewCell"];
    _collectionView.backgroundColor = QDXBGColor;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    data = @[@"01",@"02",@"03"];
    [_collectionView reloadData];
}

- (void) openOrCloseLeftList
{
    
    if ([MCLeftSliderManager sharedInstance].LeftSlideVC.closed)
    {
        [[MCLeftSliderManager sharedInstance].LeftSlideVC openLeftView];
    }
    else
    {
        [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];
    }
}

#pragma mark cell的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return data.count;
}

#pragma mark cell的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"DWViewCell";
    DWViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.showImg.image = [UIImage imageNamed:@"依次穿越"];
        cell.showLab.text = @"依次穿越";
        cell.showText.text = @"依次按提示依次到达各点标，直至终点，用时少胜。";
    }else if (row == 1){
        cell.showImg.image = [UIImage imageNamed:@"自由规划"];
        cell.showLab.text = @"自由规划";
        cell.showText.text = @"一次性给出所有点标，自行规划线路，直至寻访所有点标，用时少胜。";
    }else{
        cell.showImg.image = [UIImage imageNamed:@"自由挑战"];
        cell.showLab.text = @"自由挑战";
        cell.showText.text = @"一次性给出所有点标，在规定时间内，以寻访点标数量多为胜。";
    }
    return cell;
}

#pragma mark cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(FitRealValue(574), FitRealValue(928));
}

#pragma mark cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"点击图片%ld",indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
