//
//  ViewController.m
//  烟花效果ONE
//
//  Created by apple on 2018/6/26.
//  Copyright © 2018年 范文哲. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self makeFireworksDisplay];
}

- (void)makeFireworksDisplay {
    // 粒子发射系统 的初始化
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    // 发射源的位置
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    // 发射源尺寸大小
    fireworksEmitter.emitterSize = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    // 发射模式
    fireworksEmitter.emitterMode = kCAEmitterLayerOutline;
    // 发射源的形状
    fireworksEmitter.emitterShape = kCAEmitterLayerLine;
    // 发射源的渲染模式
    fireworksEmitter.renderMode = kCAEmitterLayerAdditive;
    // 发射源初始化随机数产生的种子
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    /**
        * 添加发射点
        一个圆（发射点）从底下发射到上面的一个过程
        */
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    rocket.birthRate = 1.0; //是每秒某个点产生的effectCell数量
    rocket.emissionRange = 0.25 * M_PI; // 周围发射角度
    rocket.velocity = 400; // 速度
    rocket.velocityRange = 100; // 速度范围
    rocket.yAcceleration = 75; // 粒子y方向的加速度分量
    rocket.lifetime = 1.02; // effectCell的生命周期，既在屏幕上的显示时间要多长。
    
    // 下面是对 rocket 中的内容，颜色，大小的设置
    rocket.contents = (id) [[UIImage imageNamed:@"circle"] CGImage];
    rocket.scale = 0.2;
    rocket.color = [[UIColor redColor] CGColor];
    rocket.greenRange = 1.0;
    rocket.redRange = 1.0;
    rocket.blueRange = 1.0;
    rocket.spinRange = M_PI; // 子旋转角度范围
    
    /**
        * 添加爆炸的效果，突然之间变大一下的感觉
        */
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    burst.birthRate = 1.0;
    burst.velocity = 0;
    burst.scale = 2.5;
    burst.redSpeed =-1.5;
    burst.blueSpeed =+1.5;
    burst.greenSpeed =+1.0;
    burst.lifetime = 0.35;
    
    /**
        * 添加星星扩散的粒子
        */
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    spark.birthRate = 400;
    spark.velocity = 125;
    spark.emissionRange = 2* M_PI;
    spark.yAcceleration = 75; //粒子y方向的加速度分量
    spark.lifetime = 3;
    
    spark.contents = (id) [[UIImage imageNamed:@"star"] CGImage];
    spark.scaleSpeed =-0.2;
    spark.greenSpeed =-0.1;
    spark.redSpeed = 0.4;
    spark.blueSpeed =-0.1;
    spark.alphaSpeed =-0.25; // 例子透明度的改变速度
    spark.spin = 2* M_PI; // 子旋转角度
    spark.spinRange = 2* M_PI;
    
    // 将 CAEmitterLayer 和 CAEmitterCell 结合起来
    fireworksEmitter.emitterCells = [NSArray arrayWithObject:rocket];
    //在圈圈粒子的基础上添加爆炸粒子
     rocket.emitterCells = [NSArray arrayWithObject:burst];
    //在爆炸粒子的基础上添加星星粒子
    burst.emitterCells = [NSArray arrayWithObject:spark];
    // 添加到图层上
    [self.view.layer addSublayer:fireworksEmitter];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    /*
    CAEmitterLayer
    
     
     CAEmitterLayer是QuartzCore提供的粒子引擎, 可用于制作美观的粒子特效。其实也可以说它是装载CAEmitterCell的容器, 有一个属性emitterCells, 将CAEmitterCell直接添加到该数组中, 即可实现粒子效果啦。
    
     
     // 可能用到是属性
    * birthRate:粒子产生系数，默认1.0；
    * emitterCells: 装着CAEmitterCell对象的数组，被用于把粒子投放到layer上；
    * emitterDepth:决定粒子形状的深度联系：emittershape
    * emitterMode:发射模式
    * emitterPosition:发射位置
    * emitterShape:发射源的形状;
    * emitterSize:发射源的尺寸大；
    * emitterZposition:发射源的z坐标位置；
    * lifetime:粒子生命周期
    * preservesDepth:不是多很清楚（粒子是平展在层上）
    * renderMode:渲染模式：
    * scale:粒子的缩放比例：
    * seed：用于初始化随机数产生的种子
    * spin:自旋转速度
    * velocity：粒子速度
     
     
     
     
     CAEmitterCell
     
     
     
     
     CAEmitterCell用来表示一个个的粒子, 它有一系列的参数用于设置效果。
     
     // 可能用到的属性
     * birthRate 这个必须要设置，具体含义是每秒某个点产生的effectCell数量
     * alphaRange:  一个粒子的颜色alpha能改变的范围；
     * alphaSpeed:粒子透明度在生命周期内的改变速度；
     * blueRange：一个粒子的颜色blue 能改变的范围；
     * blueSpeed: 粒子blue在生命周期内的改变速度；
     * color:粒子的颜色
     * contents：是个CGImageRef的对象,既粒子要展现的图片；
     * contentsRect：应该画在contents里的子rectangle：
     * emissionLatitude：发射的z轴方向的角度
     * emissionLongitude:x-y平面的发射方向
     * emissionRange；周围发射角度
     * emitterCells：粒子发射的粒子
     * enabled：粒子是否被渲染
     * greenrange: 一个粒子的颜色green 能改变的范围；
     * greenSpeed: 粒子green在生命周期内的改变速度；
     * lifetime：生命周期
     * lifetimeRange：生命周期范围
     * magnificationFilter：不是很清楚好像增加自己的大小
     * minificatonFilter：减小自己的大小
     * minificationFilterBias：减小大小的因子
     * name：粒子的名字
     * redRange：一个粒子的颜色red 能改变的范围；
     * redSpeed; 粒子red在生命周期内的改变速度；
     * scale：缩放比例：
     * scaleRange：缩放比例范围；
     * scaleSpeed：缩放比例速度：
     * spin：子旋转角度
     * spinrange：子旋转角度范围
     * style：不是很清楚：
     * velocity：速度
     * velocityRange：速度范围
     * xAcceleration:粒子x方向的加速度分量
     * yAcceleration:粒子y方向的加速度分量
     * zAcceleration:粒子z方向的加速度分量
     */
}


@end
