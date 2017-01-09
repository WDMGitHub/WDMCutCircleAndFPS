//
//  MyTableViewCell.m
//  CutCircleAndFPS
//
//  Created by wangdemin on 2017/1/6.
//  Copyright © 2017年 Demin. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
        for (int i = 0; i < 100; i++) {
            [self firstMethod];
            //第二种方法最好不用，绘制时CPU负荷过重，绘制很慢，还没第一种方法好，绘制10000张的时候直接闪退了
//                [self secondMethod];
//                [self thirdMethod];
        }
        
}

//第一种方法：通过设置layer的属性
//最简单的一种，但是很影响性能，一般在正常的开发中使用很少（这是网上说的，目前不适用了）
- (void)firstMethod {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 70, 70)];
//    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"女帝.jpg"];
    //只需要设置layer层的两个属性
    //设置圆角
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    //将多余的部分切掉
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
}

//第二种方法：使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
- (void)secondMethod {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 70, 70)];
//    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"女帝.jpg"];
    
    //开始对imageView进行画圆
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];
    [imageView drawRect:imageView.bounds];
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画圆
    UIGraphicsEndImageContext();
    [self.contentView addSubview:imageView];
}

//第三种方法：使用CAShapeLayer和UIBezierPath设置圆角
//首先需要导入<AVFoundation/AVFoundation.h>
- (void)thirdMethod {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 70, 70)];
//    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"女帝.jpg"];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    [self.contentView addSubview:imageView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
