//
//  TwoViewController.m
//  FanyiApp
//
//  Created by 1111 on 2017/7/19.
//  Copyright © 2017年 ljl. All rights reserved.
//
#define KWS(weakSelf) __weak __typeof(&*self) weakSelf=self
#define WeakSelf(self) __weak typeof(self) weakSelf = self;
#import "TwoViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "LineLayout.h"
#import "TwoCell.h"
#import "TwoModel.h"
#import "MJRefresh.h"
#import <AVFoundation/AVFoundation.h>
#import "UIScrollView+PSRefresh.h"
@interface TwoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    LineLayout *linglayout;
    NSMutableArray *dataArray;
    UICollectionView *_myCollectionView;
    NSInteger indepage;
}


@end
static NSString * const PhotoCellId = @"mycell";

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; 
     dataArray = [[NSMutableArray alloc]init];
    [self congfiguiNavbar];
    indepage=1;
   
   [self configuitableview];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)congfiguiNavbar{
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
    UIApplication *app = [UIApplication sharedApplication];
    
    app.statusBarStyle = UIStatusBarStyleLightContent ;
    
   



}
-(void)configuitableview{

//    if(!_myCollectionView){
        /**
         注意：初始化collectionView 通过frame和layout 一定要传进去一个layout
         */
    
    
   linglayout=[[LineLayout alloc] init];
    
//    _defauleLayout.itemSize=CGSizeMake((self.view.frame.size.width-10)/2, 230);
//    linglayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        _myCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49) collectionViewLayout:linglayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
//   _myCollectionView.backgroundColor = [UIColor redColor];
//        _myCollectionView.showsVerticalScrollIndicator=NO;
//        _myCollectionView.showsHorizontalScrollIndicator=NO;
        //注册cell
       [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TwoCell class]) bundle:nil] forCellWithReuseIdentifier:PhotoCellId];
    
    [self.view addSubview:_myCollectionView];
//    [self addRefreshHeader:NO andHaveFooter:YES];
    
//        _myCollectionView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:0.8];
        //用头视图要线注册
//        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//        
    
        //       [_myCollectionView registerClass:[UICollectionReusableView class] forCellWithReuseIdentifier:<#(nonnull NSString *)#>]
        
        
//    }
//    return _myCollectionView;
 WeakSelf(self)
    
    [_myCollectionView addRefreshHeaderWithClosure:^{
//        [weakSelf refreshData];
    } addRefreshFooterWithClosure:^{
        [weakSelf loadingData];
    }];
    
//    [_myCollectionView addGifRefreshHeaderWithClosure:^{
//        
////       [weakSelf refreshData];
//    } addGifRefreshFooterWithClosure:^{
//     [weakSelf loadingData];
//    }];
    
}
-(void)loadData{
//api=sentence_info&displayNumber=25&pageIndex=1
    
//    NSLog(@"11111111");
    NSString *str =[NSString stringWithFormat:@"%ld",indepage];
    NSDictionary *dic = @{@"api":@"sentence_info",@"displayNumber":@"25",@"pageIndex":str};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:@"http://115.29.149.225/everyday_english_test/Interface.php/" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        NSArray *ar = responseObject[@"data"];
        for (NSDictionary *dic in ar) {
            
            TwoModel *model = [[TwoModel alloc]initWithDictionary:dic error:nil];
            
            [dataArray addObject:model];
        }
        
//        NSLog(@"%@",responseObject);
        [_myCollectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // NSLog(@"%@",error);
    }];
    





}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return dataArray.count;
//    NSLog(@"%d",dataArray.count);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    TwoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:PhotoCellId forIndexPath:indexPath];
    
    
    TwoModel *model = dataArray[indexPath.row];
    
    cell.mycelltitlable.text = [NSString stringWithFormat:@"%@\n%@",model.content,model.note];
    [cell.mycellimageview sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    cell.titlelable.text = model.dateline;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(cell.mycellimageview.frame.size.width-30, cell.mycellimageview.frame.size.height-30, 25, 25)];
//  /  [btn setTitle:@"adwo_videoMute" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"adwo_videoMute"] forState:UIControlStateNormal];
    btn.tag = 100+indexPath.row;
    [btn addTarget:self action:@selector(fanyibtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
   return cell;
}
-(void)fanyibtn:(UIButton *)btn{

    TwoModel *model = dataArray[btn.tag-100];
    
//    NSLog(@"%@",model.content);
    NSString *s = [NSString stringWithFormat:@"%@\n%@",model.content,model.note];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:s];
    //    utterance.rate = 2;
    utterance.pitchMultiplier=1.0;
    //中式发音
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    //英式发音
    // AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
    utterance.voice = voice;
    //    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
    [synth speakUtterance:utterance];
    
//    NSLog(@"点了");

}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
//    NSLog(@"%f",self.view.frame.size.width);
    
    if (self.view.frame.size.width<350) {
        
        
        return  CGSizeMake(220, 300);
    }if (self.view.frame.size.width>700) {
        
        return CGSizeMake(400, 500);
        
    }else{
    
    return CGSizeMake (250,400);
    }
}
//-(void)addRefreshHeader:(BOOL)ishavHeader andHaveFooter:(BOOL) havFooter
//{
//    //风格要一致,要么用block,要么用第一个
//    if (ishavHeader) {
//        _myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
//        //这个是开始加载数据
//        [_myCollectionView.mj_header beginRefreshing];
//    }
//    if(havFooter){
//        KWS(ws);
//        _myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            //上啦加载更多
//            [ws loadMore];
//        }];
//        
//    }
//}
-(void)loadMore{
    
//    [_tableView.mj_footer endRefreshing];
//    SYModel *model =_dataArray.lastObject;
    //    _currentPage=_currentPage-15;
    
//    [self loadDatatwo:model.ida];
    
}
- (void)refreshData {
//    self.dataArray = [NSMutableArray arrayWithObjects:@1, @2, @3, nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      _myCollectionView.isLastPage = NO;
        [_myCollectionView endRefreshing];
        
        
        
//        [_myCollectionView reloadData];
    });
}
- (void)loadingData {
//    for (int i = 0; i < 3; i ++) {
//        [self.dataArray addObject:@0];
//    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        indepage++;
        [self loadData];
       [_myCollectionView endRefreshing];
//        if (self.dataArray.count > 7) {
//            self.collectionView.isLastPage = YES;
//        }
//        [self.collectionView reloadData];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
