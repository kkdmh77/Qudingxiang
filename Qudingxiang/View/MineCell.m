//
//  MineCell.m
//  Qudingxiang
//
//  Created by Mac on 15/10/10.
//  Copyright © 2015年 Air. All rights reserved.
//

#import "MineCell.h"
#import "Myline.h"
@interface MineCell()
{
    UILabel *_desLabel;
    UILabel *_nameLabel;
    UILabel *_statusLabel;
    UIImageView *_imageView;
}
@end
@implementation MineCell

+ (instancetype)baseCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"ID";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //添加cell的子控件
        [cell addSubViews];
    }
    return cell;
    
}

- (void)addSubViews
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QdxWidth, FitRealValue(20))];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.contentView addSubview:view];
    _imageView = [ToolView createImageWithFrame:CGRectMake(0, FitRealValue(20), FitRealValue(150), FitRealValue(150))];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.image = [UIImage imageNamed:@""];
    CALayer *lay  = _imageView.layer;//获取ImageView的层
    [lay setMasksToBounds:NO];
    //[lay setCornerRadius:45.0];
    [self.contentView addSubview:_imageView];
    
    _desLabel = [ToolView createLabelWithFrame:CGRectMake(FitRealValue(170), FitRealValue(60), QdxWidth-30, FitRealValue(20)) text:@"路线" font:15 superView:self.contentView];
    _desLabel.textColor = QDXBlack;
    _nameLabel = [ToolView createLabelWithFrame:CGRectMake(FitRealValue(170), FitRealValue(60 + 20 + 40), QdxWidth-30, FitRealValue(20)) text:@"名字" font:12 superView:self.contentView];
    _nameLabel.textColor = QDXGray;
    UIImageView *rightView = [[UIImageView alloc] init];
    rightView.frame = CGRectMake(QdxWidth - FitRealValue(48), 10+FitRealValue(150)/2-5,FitRealValue(16), FitRealValue(24));
    rightView.image = [UIImage imageNamed:@"activity_arrow"];
    [self.contentView addSubview:rightView];
}

-(void)setMyline:(Myline *)myline
{
    _myline = myline;
    _desLabel.text = [NSString stringWithFormat:@"%@",myline.line_cn];
    _nameLabel.text = [NSString stringWithFormat:@"%@",myline.myline_preview];
    _statusLabel.text = [NSString stringWithFormat:@"%@",myline.mylinest_cn];
    if([myline.mylinest_id isEqualToString:@"4"]){
        _imageView.image = [UIImage imageNamed:@"强制结束"];
    }else if([myline.mylinest_id isEqualToString:@"1"]){
        _imageView.image = [UIImage imageNamed:@"未开始"];
    }else if([myline.mylinest_id isEqualToString:@"3"]){
        _imageView.image = [UIImage imageNamed:@"已完成"];
    }else if([myline.mylinest_id isEqualToString:@"5"]){
        _imageView.image = [UIImage imageNamed:@"超时结束"];
    }else if([myline.mylinest_id isEqualToString:@"2"]){
        _imageView.image = [UIImage imageNamed:@"活动中"];
    }
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
