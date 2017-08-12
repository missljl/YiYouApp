//
//  MyTabViewController.m
//  Comic island
//
//  Created by qianfeng on 15-11-2.
//  Copyright (c) 2015年 李金龙. All rights reserved.
//




#import "MyTabViewController.h"
//#import "RootViewController.h"
@interface MyTabViewController ()
//{
//
//    UIImageView *_iamgeview;
//}
@end

@implementation MyTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViewController];
    
//    [self customTabBar];
    
//    [self lastSelected];
}


-(void)createViewController
{
 NSArray *vcName = @[@"FirstViewController",@"TwoViewController"];
    NSArray *titleNarray = @[@"翻译",@"每日一句"];
    
    NSArray *imagear =@[@"Channel-Icon-Home-Nomal",@"Channel-Icon-More-Normal"];
//    NSArray *imagesected =@[@"Channel-Icon-Home-Highlighted@2x",@"Channel-Icon-More-Highlighted@2x",@"Channel-Icon-PersonalCenter-Highlighted@2x"];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<vcName.count; i++) {
        Class class = NSClassFromString(vcName[i]);
        if (class) {
            UIViewController *vc =[[class alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            
//            
//            [nav.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bc_topBg@2x"] forBarMetrics: UIBarMetricsDefaultPrompt ];
            vc.tabBarItem.title =titleNarray[i];
            vc.tabBarItem.image =[UIImage imageNamed:imagear[i]];
//            vc.tabBarItem.selectedImage =[UIImage imageNamed:imagesected[i]];
            [viewControllers addObject:nav];
            vc.title = titleNarray[i];
//              self.tabBar.tintColor = [UIColor redColor];
            //设置初始状态选中的下标
            self.selectedIndex = 0;
            //设置标签栏的颜色
            self.tabBar.barTintColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
//            self.tabBar.alpha=0.5;
            //修改条行条颜色
           
//            //修改导航栏字体颜色
           [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:22], NSFontAttributeName, nil]];
          
        }
    }
    //写copy的原因:避免tab.viewControllers指向的数组是可变的,提高安全性,和稳定性
    self.viewControllers =viewControllers;
    
}
//-(void)customTabBar
//{
//     self.tabBar.hidden = YES;//影藏标签栏
//    _iamgeview = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
//   // _iamgeview.image = [UIImage imageNamed:@"25_2.jpg"];
//    _iamgeview.alpha = 0.7;
//    _iamgeview.userInteractionEnabled = YES;
//    [self.view addSubview:_iamgeview];
//    _iamgeview.backgroundColor = [UIColor whiteColor];
//   
//}
//-(void)lastSelected
//{
//    NSArray *titileArray = @[@"推荐",@"分类",@" ",@"专题",@"书架"];
//    
//    NSArray *imageArray = @[@"tab2_nor",@"tab4_nor",@"tab3_nor",@"tab5_nor",@"tab1_nor"];
//    
//    NSArray *imageselectedArray =@[@"tab2_sel",@"tab4_sel",@"tab3_sel",@"tab5_sel",@"tab1_sel"];
//    
//    for (NSInteger i=0; i<titileArray.count; i++) {
//        
//        UIButton *btnitem = [[UIButton alloc]initWithFrame:CGRectMake((5+63*i)*RATE, 11, 58*RATE, 49-11)];
//        [_iamgeview addSubview:btnitem];
//        
//        [btnitem addTarget:self action:@selector(btnCilck:) forControlEvents:UIControlEventTouchUpInside];
//        btnitem.tag=100+i;
//        [btnitem setTitle:titileArray[i] forState:UIControlStateNormal];
//        [btnitem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btnitem setTitleColor:TITLE_COLOR forState:UIControlStateSelected];
//        btnitem.titleLabel.font = [UIFont systemFontOfSize:9];
//        btnitem.titleEdgeInsets = UIEdgeInsetsMake(20, -25, 0, 0);
//        btnitem.imageEdgeInsets = UIEdgeInsetsMake(-15,0 ,0 ,-24*RATE );
//        [btnitem setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
//        [btnitem setImage:[UIImage imageNamed:imageselectedArray[i]] forState:UIControlStateSelected];
//        if (i==2) {
//            
//           btnitem.imageEdgeInsets = UIEdgeInsetsMake(-48, -7*RATE, 0, 0);
//        btnitem.frame=CGRectMake((5+63*i)*RATE, 11, 66*RATE, 74-11);
//
//        }
//        btnitem.adjustsImageWhenHighlighted = YES;
//        _iamgeview.userInteractionEnabled = YES;
//        if (i==0) {
//            btnitem.selected = YES;
//        
//        btnitem.userInteractionEnabled = NO;
//        }
//    }
//    
//}
//-(void)btnCilck:(UIButton *)btnitem
//{
//    NSInteger index = btnitem.tag-100;
//    self.selectedIndex = index;
//    for (UIButton *btnitem in _iamgeview.subviews) {
//        btnitem.selected = NO;
//        btnitem.userInteractionEnabled = YES;
//    }
//    btnitem.selected = YES;
//}
@end
