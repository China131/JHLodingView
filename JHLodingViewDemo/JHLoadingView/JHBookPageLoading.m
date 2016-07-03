//
//  JHBookPageLoading.m
//  JHLodingViewDemo
//
//  Created by 简豪 on 16/7/1.
//  Copyright © 2016年 codingMan. All rights reserved.
//

#import "JHBookPageLoading.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:244/255.0 green:161/255.0 blue:100/255.0 alpha:1],[UIColor colorWithRed:87/255.0 green:255/255.0 blue:191/255.0 alpha:1],                     [UIColor colorWithRed:254/255.0 green:224/255.0 blue:90/255.0 alpha:1],                     [UIColor colorWithRed:240/255.0 green:58/255.0 blue:63/255.0 alpha:1],                          [UIColor colorWithRed:147/255.0 green:111/255.0 blue:255/255.0 alpha:1],                    [UIColor colorWithRed:255/255.0 green:255/255.0 blue:199/255.0 alpha:1],                    [UIColor colorWithRed:90/255.0 green:159/255.0 blue:229/255.0 alpha:1],                     [UIColor colorWithRed:100/255.0 green:230/255.0 blue:95/255.0 alpha:1],                     [UIColor colorWithRed:33/255.0 green:255/255.0 blue:255/255.0 alpha:1],                     [UIColor colorWithRed:249/255.0 green:110/255.0 blue:176/255.0 alpha:1],                        [UIColor colorWithRed:192/255.0 green:168/255.0 blue:250/255.0 alpha:1],                    [UIColor colorWithRed:166/255.0 green:134/255.0 blue:54/255.0 alpha:1],                     [UIColor colorWithRed:217/255.0 green:221/255.0 blue:228/255.0 alpha:1],                    [UIColor colorWithRed:99/255.0 green:106/255.0 blue:192/255.0 alpha:1]]


@interface JHBookPageLoading ()


@property (nonatomic,strong)NSMutableArray * layersArr;

@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,assign) BOOL isBack;

@property (nonatomic,assign) NSInteger lastIndex;
@end



@implementation JHBookPageLoading

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self configBaseView];
       
        
    }
    return self;
}



#pragma mark---------------------->从左向右的翻页动画
- (void)configLayer{
  
    
    CALayer *layer = nil;
    
    /*        少于20页时创建并添加到数组         */
    if (_layersArr.count<20) {
        
        /*        使用类方法创建CAlayer对象         */
        layer = [CALayer layer];
        
        /*        CATransform实际上是一个结构体 因此不能直接对内部元素直接赋值         */
        CATransform3D transform = layer.transform;
        
        /*        设置layer的立体效果值 m34为该值 渲染立体效果         */
        transform.m34 = 10.5/-2000;
        
        layer.transform = transform;
        
        /*        设置layer的背景颜色，注意是CGColor类型         */
        layer.backgroundColor = [k_COLOR_STOCK[_currentIndex%k_COLOR_STOCK.count] CGColor];
        
        /*        设置锚点，锚点即动画的中心点，默认为(二维环境)（0.5.0.5）,分别表示X轴中点 Y轴中点         */
        layer.anchorPoint = CGPointMake(0, 0.5);
        
        layer.frame = CGRectMake(200, 100, 30, 45);
        
        /*        设置layer的中心点，相当于UIView对象的center熟悉         */
        layer.position = CGPointMake(K_IOS_WIDTH/2, K_IOS_HEIGHT/2-50);
        
        [self.layer addSublayer:layer];
        
         [_layersArr addObject:layer];
    }else{
        
        layer = _layersArr[_currentIndex%20];
        
    }
    
  
    /*        首先移除之前添加的动画         */
    [layer removeAnimationForKey:@"base"];
    
    /*        创建翻页动画         */
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    /*        transform.rotation.y的动画开始值         */
    basic.fromValue  = @(-M_PI );
    
    /*        transform.rotation.y的动画结束值         */
    basic.toValue = @(0);
    
    /*        是否在动画结束后自动按照反向动画回归原状态         */
    basic.autoreverses = NO;
    
    /*        动画执行次数         */
    basic.repeatCount = 1;
    
    /*        动画时长         */
    basic.duration = 1.0;
    
    /*        动画填充模式         */
    basic.fillMode = kCAFillModeRemoved;
    
    /*        设置代理         */
    basic.delegate = self;
    [layer addAnimation:basic forKey:@"basc"];
     NSLog(@"---%ld",_lastIndex);
    _lastIndex = _currentIndex;
    _currentIndex ++;

    
}

- (void)configBaseView{
    _currentIndex = 0;
    _layersArr = [NSMutableArray array];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(configLayer) userInfo:nil repeats:YES];
    [_timer fire];

}


#pragma mark---------------------->从右至左翻页动画的实现
- (void)backLayer{
    
    CALayer *layer = _layersArr[19-_currentIndex%20];

    [layer removeAnimationForKey:@"basc"];
    
    _lastIndex = 19 -_currentIndex%20;
    
    NSLog(@"%ld",_lastIndex);
    
    if (_lastIndex==0) {
        [_timer invalidate];
    }
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    basic.fromValue  = @(0);
    basic.toValue = @(-M_PI );
  
    basic.autoreverses = NO;
    basic.repeatCount = 0;
    basic.delegate = self;
    
    basic.duration = 1.0;
    basic.fillMode = kCAFillModeRemoved;
    _currentIndex ++;
    [layer addAnimation:basic forKey:@"basc"];
    
    
    
}


#pragma mark---------------------->动画代理方法 用于监听动画执行的状态
-(void)animationDidStart:(CAAnimation *)anim{

    
    /*        为了方便对不同状态的动画进行处理 将判断语句分离出来         */
    if (_currentIndex==20&&!_isBack) {
         _isBack = !_isBack;
        
        _currentIndex = 0;
        _lastIndex = 0;
        [_timer invalidate];
        _timer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(backLayer) userInfo:nil repeats:YES];
            [_timer fire];
            
        });
    }
    
    
    
    if (_currentIndex==20&&_isBack) {
        
        _isBack = !_isBack;
        _currentIndex = 0;
        [_timer invalidate];
        _timer = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(configLayer) userInfo:nil repeats:YES];
            [_timer fire];
            
        });
        

    }
    
    
    return;
    
}

@end