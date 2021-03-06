//
//  LocationChoiceViewController.m
//  趣定向
//
//  Created by Air on 2017/3/6.
//  Copyright © 2017年 Air. All rights reserved.
//

#import "LocationChoiceViewController.h"
#import "ChoseCityCollectionViewCell.h"

@interface LocationChoiceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UIButton *locationCityBtn;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

static NSString *ChoseCityReuseID = @"ChoseCityReuseID";

@implementation LocationChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"切换城市";
    
    [self setupUI];
}

-(void)setupUI
{
    UILabel *locationCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitRealValue(20), FitRealValue(40), FitRealValue(218), FitRealValue(30))];
    locationCityLabel.text = @"定位城市";
    locationCityLabel.textColor = QDXGray;
    locationCityLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:locationCityLabel];
    
    self.locationCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(FitRealValue(20), FitRealValue(90), FitRealValue(218), FitRealValue(80))];
    self.locationCityBtn.layer.cornerRadius = 3;
    [self.locationCityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.locationCityBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.locationCityBtn setTitle:self.location forState:UIControlStateNormal];
    [self.locationCityBtn addTarget:self action:@selector(locationCityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.locationCityBtn.backgroundColor = QDXBlue;
    [self.view addSubview:self.locationCityBtn];
    
    UILabel *openCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(FitRealValue(20), FitRealValue(205), FitRealValue(218), FitRealValue(30))];
    openCityLabel.text = @"开放城市";
    openCityLabel.textColor = QDXGray;
    openCityLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:openCityLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(FitRealValue(220), FitRealValue(80));
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10 ;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(FitRealValue(20), FitRealValue(260), QdxWidth - FitRealValue(40), FitRealValue(500)) collectionViewLayout:layout];
    self.collectionView.backgroundColor = QDXBGColor;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    self.collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
    
    [self.collectionView registerClass:[ChoseCityCollectionViewCell class] forCellWithReuseIdentifier:ChoseCityReuseID];
    
    [self.view addSubview:self.collectionView];
}

-(void)locationCityBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --------------------------------------------------
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChoseCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChoseCityReuseID forIndexPath:indexPath];
    cell.city = self.items[indexPath.row];
    cell.btnBlock = ^(){
        [self.delegate choseCityPassValue:self.items[indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
