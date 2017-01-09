//
//  ViewController.m
//  CutCircleAndFPS
//
//  Created by wangdemin on 2017/1/5.
//  Copyright © 2017年 Demin. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MyTableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 40)];
//    [self.view addSubview:label];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"请问圆角怎么(ˉ▽￣～) 切~~";
//    for (int i = 0; i < 10000; i++) {
//        [self firstMethod];
//        //第二种方法最好不用，绘制时CPU负荷过重，绘制很慢，还没第一种方法好，绘制10000张的时候直接闪退了
////            [self secondMethod];
////            [self thirdMethod];
//    }
//    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellID"];
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    return cell;
}

//第一种方法：通过设置layer的属性
//最简单的一种，但是很影响性能，一般在正常的开发中使用很少（这是网上说的，目前这种方法最好）
- (void)firstMethod {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"女帝.jpg"];
    //只需要设置layer层的两个属性
    //设置圆角
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    //将多余的部分切掉
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
}

//第二种方法：使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
- (void)secondMethod {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"女帝.jpg"];
    
    //开始对imageView进行画圆
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];
    [imageView drawRect:imageView.bounds];
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画圆
    UIGraphicsEndImageContext();
    [self.view addSubview:imageView];
}

//第三种方法：使用CAShapeLayer和UIBezierPath设置圆角
//首先需要导入<AVFoundation/AVFoundation.h>
- (void)thirdMethod {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"女帝.jpg"];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    [self.view addSubview:imageView];
}

//这三种方法中第三种最好，对内存的消耗最少，而且渲染快速（这是网上说的，目前不适用了）
//上面这句话是网上说的，经过测试，目前第一种最好

@end
