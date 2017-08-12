//
//  FirstViewController.m
//  FanyiApp
//
//  Created by 1111 on 2017/7/19.
//  Copyright © 2017年 ljl. All rights reserved.
//

#import "FirstViewController.h"

#import "HttpManager.h"


#import <AVFoundation/AVFoundation.h>


#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"

#import "ValuePickerView.h"

#import "MBProgressHUD.h"


#import "CameraViewController.h"


@interface FirstViewController ()<UITextViewDelegate,IFlyRecognizerViewDelegate,CameraDelegate>



@property(nonatomic,strong)UITextView *shutextview;
@property(nonatomic,strong)UILabel *shuiproclable;
@property(nonatomic,strong)UITextView *xianshitextview;
@property(nonatomic,strong)UIView *counteview;


@property(nonatomic,strong)IFlyRecognizerView *iFlySpeechRecognizer;;
@property (nonatomic, strong) ValuePickerView *pickerView;

//键盘上的三个按钮
@property(nonatomic,strong)UIButton *btn;
//中间视图上面的按钮
@property(nonatomic,strong)UIButton *countleftbtn;
@property(nonatomic,strong)UIButton *countrightbtn;
@property(nonatomic,strong)UIImageView *countimageview;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,assign)NSInteger qianindex;
@property(nonatomic,assign)NSInteger houindex;
@property(nonatomic,strong)AVSpeechSynthesisVoice *voice;

//@property(nonatomic,strong)UITextView *xianshitextview;
//相机相册ku
@property(nonatomic, strong) CameraViewController *cameraViewvController;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) BOOL isCiOrJu;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //pickview默认值
    self.qianindex=0;
    self.houindex=0;
    //单线程
    _isCiOrJu = NO;
    self.operationQueue = [[NSOperationQueue alloc] init];
    //点击多种语言的滚动
     self.pickerView = [[ValuePickerView alloc]init];
    //导航栏等一些列操作
    [self congfiguiNavbar];
    //翻译输入框
    [self congfigUItextview];
    //中间view
    [self configUIcountView];
    //翻译结果显示狂
    [self configUIcountfanyiview];
    
    //键盘按钮3个按钮
    [self keybodbtns];
    //翻译输入框中的3个按钮
    [self shutextviewbtns];
}


-(void)congfiguiNavbar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets= NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
    UIApplication *app = [UIApplication sharedApplication];
    
    app.statusBarStyle = UIStatusBarStyleLightContent ;
    
    
    
    
    
}
//要翻译的texteview
-(void)congfigUItextview{


    _shutextview = [[UITextView alloc]init];
    
    _shutextview.delegate =self;
    
    _shutextview.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.height-111-35)/2);
    _shutextview.backgroundColor = [UIColor whiteColor];
//_shutextview.text = @"";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8; //行距
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
    
    _shutextview.attributedText = [[NSAttributedString alloc]initWithString: _shutextview.text attributes:attributes];
    
    
    
    _shutextview.textAlignment = NSTextAlignmentNatural; // 设置字体对其方式
    _shutextview.font = [UIFont boldSystemFontOfSize:15]; // 设置字体大小
    _shutextview.textColor = [UIColor lightGrayColor]; // 设置文字颜色
    [_shutextview setEditable:YES]; // 设置时候可以编辑
    _shutextview.dataDetectorTypes = UIDataDetectorTypeNone; // 显示数据类型的连接模式（如电话号码、网址、地址等）
    _shutextview.keyboardType = UIKeyboardTypeDefault; // 设置弹出键盘的类型
    _shutextview.returnKeyType = UIReturnKeySearch; // 设置键盘上returen键的类型
    _shutextview.scrollEnabled = YES; // 当文字宽度超过UITextView的宽度时，是否允许滑动
    
    
    _shutextview.layer.borderWidth = 2.0;
//    _shutextview.layer.masksToBounds = YES;
    _shutextview.layer.cornerRadius = 4.0;
    _shutextview.layer.borderColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0].CGColor;
    
    
    _shuiproclable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    _shuiproclable.text = @"🎙️请输入要翻译的文字或句子......";
    _shuiproclable.textColor = [UIColor lightGrayColor];
    _shuiproclable.textAlignment = NSTextAlignmentLeft;
    _shuiproclable.font = [UIFont systemFontOfSize:14];
    [_shutextview addSubview:_shuiproclable];
    [self.view addSubview:_shutextview];


}
//中间view
-(void)configUIcountView{


    _counteview = [[UIView alloc]initWithFrame:CGRectMake(0, _shutextview.frame.origin.y+_shutextview.frame.size.height, self.view.frame.size.width, 70)];

    _counteview.userInteractionEnabled= YES;
    _counteview.backgroundColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
    [self.view addSubview:_counteview];
    

    
    _countimageview  =[[UIImageView alloc]initWithFrame:CGRectMake(_counteview.frame.size.width/2-25, 10, 50, 50)];
    _countimageview.image = [UIImage imageNamed:@"1"];
    [_counteview addSubview:_countimageview];
    
    _countleftbtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 10, 100, 50)];
    [_countleftbtn setTitle:@"中文" forState:UIControlStateNormal];
    [_countleftbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _countleftbtn.backgroundColor =[UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
     _countleftbtn.layer.borderWidth = 2.0;
    _countleftbtn.layer.masksToBounds = YES;
    _countleftbtn.layer.cornerRadius = 17.0;
    _countleftbtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_countleftbtn addTarget:self action:@selector(leftbtn:) forControlEvents:UIControlEventTouchUpInside];
    _countleftbtn.tag=300;
    [_counteview addSubview:_countleftbtn];
    
    
    
    
    _countrightbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-125, 10, 100, 50)];
    [_countrightbtn setTitle:@"英文" forState:UIControlStateNormal];
    [_countrightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _countrightbtn.backgroundColor =[UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
    _countrightbtn.layer.borderWidth = 2.0;
    _countrightbtn.layer.masksToBounds = YES;
    _countrightbtn.layer.cornerRadius = 17.0;
    _countrightbtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_countrightbtn addTarget:self action:@selector(leftbtn:) forControlEvents:UIControlEventTouchUpInside];
    _countrightbtn.tag=301;
    [_counteview addSubview:_countrightbtn];

    



}
-(void)leftbtn:(UIButton *)btn{

    if (btn.tag==300){
        
        self.pickerView.dataSource = @[@"中文",@"英文",@"日文",@"韩文",@"法文",@"俄语",@"德语"];
        self.pickerView.pickerTitle = @"语言类别";
         __weak typeof(self) weakSelf = self;
        self.pickerView.valueDidSelect = ^(NSString *value){
            NSArray * stateArr = [value componentsSeparatedByString:@"/"];
//            btn.titleLabel.text= stateArr[0];
              [weakSelf.countleftbtn setTitle:stateArr[0] forState:UIControlStateNormal];
             weakSelf.qianindex =[stateArr[1] intValue];
            
            
//            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        };
        
        [self.pickerView show];
        
        
//        NSLog(@"中间自动检测按钮");
    }else{
        self.pickerView.dataSource = @[@"英文",@"日文",@"韩文",@"法文",@"俄语",@"德语",@"中文"];
        self.pickerView.pickerTitle = @"翻译类型";
       __weak typeof(self) weakSelf = self;
//        self.pickerView.defaultStr = @"50%/5";
        self.pickerView.valueDidSelect = ^(NSString *value){
            NSArray * stateArr = [value componentsSeparatedByString:@"/"];
            [weakSelf.countrightbtn setTitle:stateArr[0] forState:UIControlStateNormal];
            
               weakSelf.houindex =[stateArr[1] intValue];
//            _countleftbtn.titleLabel.text = btn.titleLabel.text;
//            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        };
        [self.pickerView show];

//        NSLog(@"英文按钮");

    
    }
    
//    NSLog(@"中间自动检测按钮");


}



//翻译结果textview
-(void)configUIcountfanyiview{

    _xianshitextview = [[UITextView alloc]init];
    
//    _xianshitextview.delegate =self;
    
    _xianshitextview.frame = CGRectMake(0, _counteview.frame.origin.y+_counteview.frame.size.height, self.view.frame.size.width,_shutextview.frame.size.height);
    _xianshitextview.backgroundColor = [UIColor whiteColor];
    //_shutextview.text = @"";
    _xianshitextview.textAlignment = NSTextAlignmentNatural; // 设置字体对其方式
    _xianshitextview.font = [UIFont boldSystemFontOfSize:15]; // 设置字体大小
    _xianshitextview.textColor = [UIColor lightGrayColor]; // 设置文字颜色
    [_xianshitextview setEditable:NO]; // 设置时候可以编辑
//    _shutextview.dataDetectorTypes = UIDataDetectorTypeAll; // 显示数据类型的连接模式（如电话号码、网址、地址等）
//    _shutextview.keyboardType = UIKeyboardTypeDefault; // 设置弹出键盘的类型
//    _shutextview.returnKeyType = UIReturnKeySearch; // 设置键盘上returen键的类型
    _xianshitextview.scrollEnabled = YES; // 当文字宽度超过UITextView的宽度时，是否允许滑动
    
    
    _xianshitextview.layer.borderWidth = 2.0;
    _xianshitextview.layer.masksToBounds = YES;
    _xianshitextview.layer.cornerRadius = 4.0;
    _xianshitextview.layer.borderColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0].CGColor;

    [self.view addSubview:_xianshitextview];


    //语音播放按钮
    UIButton *_xianshixiabtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, self.view.frame.size.height-110,45,45)];
    [_xianshixiabtn setImage:[UIImage imageNamed:@"33"] forState:UIControlStateNormal];
    _xianshixiabtn.layer.cornerRadius=_xianshixiabtn.frame.size.width/2;
//    _xianshitextview.layer.masksToBounds = YES;
    _xianshixiabtn.layer.borderWidth = 2.0;
    _xianshixiabtn.layer.masksToBounds = YES;
//    _xianshitextview.layer.cornerRadius = 4.0;
    _xianshixiabtn.layer.borderColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0].CGColor;
//    _xianshixiabtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
    [_xianshixiabtn addTarget:self action:@selector(xianshixiabtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xianshixiabtn];
    [self.view bringSubviewToFront:_xianshixiabtn];
    
    
    
    
    
    
}
//语音播报点击事件
-(void)xianshixiabtn{

//    NSLog(@"要语音播放的翻译结果");
   //想说的话
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:_xianshitextview.text];
//    utterance.rate=AVSpeechUtteranceDefaultSpeechRate;
    //语速
    utterance.rate = 0.4;
    //语言声调
    utterance.pitchMultiplier=1.3;
    //中式发音
//    NSArray *houar = @[@"en",@"jp",@"kor",@"fra",@"ru",@"de",@"zh"];
 
    if (self.houindex==0) {
        
       self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        
    }if (self.houindex==1) {
    self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ja-JP"];
    }if (self.houindex==2) {
        
      self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ko-KR"];
        
    }if (self.houindex==3) {
        
        self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"fr-CA"];
        
    }if (self.houindex==4) {
        
        self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ru-RU"];
        
    }if (self.houindex==5) {
        
        self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"sv-SE"];
        
    }if (self.houindex==6) {
        
        self.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        
    }
   
    //英式发音
    // AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
    utterance.voice = self.voice;
//    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc]init];
    [synth speakUtterance:utterance];
    
    

}


//给键盘添加三个按钮
-(void)keybodbtns{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    _shutextview.inputAccessoryView = view;
    
    NSArray *titlear = @[@"清空",@"取消",@"翻译"];

    for (NSInteger i=0; i<titlear.count; i++) {
        _btn = [[UIButton alloc]init];
        if (i==0||i==1) {
            
        _btn.frame= CGRectMake(10+(55*i), 0,50, 50);
            
        }else{
         _btn.frame= CGRectMake(self.view.frame.size.width-70, 0,50, 50);
//        _btn.frame= CGRectMake(self.view.frame.size.width-70,0,50, 50);
            
        }
        [_btn setTitle:titlear[i] forState:UIControlStateNormal];
        
        [_btn setTitleColor:[UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0] forState:UIControlStateNormal];
        _btn.tag = 100+i;
        
        [_btn addTarget:self action:@selector(keybtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:_btn];
        
        
    }
    




}
//输入textview上面的2按钮
-(void)shutextviewbtns{

//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, _shutextview.frame.origin.y+_shutextview.frame.size.height-40, self.view.frame.size.width, 40)];
//    view.backgroundColor = [UIColor redColor];
//    view.userInteractionEnabled = YES;
//    [self.view addSubview:view];
//    [self.view bringSubviewToFront:view];
    
  
    UIButton *yuynbtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-115, _shutextview.frame.origin.y+_shutextview.frame.size.height-55,45,45)];
    [yuynbtn setImage:[UIImage imageNamed:@"btn_voice"] forState:UIControlStateNormal];
     yuynbtn.layer.cornerRadius=yuynbtn.frame.size.width/2;
    yuynbtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
    [yuynbtn addTarget:self action:@selector(yuyinbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yuynbtn];
     [self.view bringSubviewToFront:yuynbtn];
    
    
    UIButton *fanyibtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, _shutextview.frame.origin.y+_shutextview.frame.size.height-55,45,45)];
    fanyibtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
    [fanyibtn setTitle:@"翻译" forState:UIControlStateNormal];
     fanyibtn.layer.cornerRadius=fanyibtn.frame.size.width/2;
    [fanyibtn addTarget:self action:@selector(fanyibtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fanyibtn];
    [self.view bringSubviewToFront:fanyibtn];
//    _shutextview.text = @"🎙️"
    
    UIButton *potoibtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-170, _shutextview.frame.origin.y+_shutextview.frame.size.height-55,45,45)];
    potoibtn.layer.borderColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0].CGColor;
    potoibtn.layer.borderWidth = 1.0;
    [potoibtn setBackgroundImage:[UIImage imageNamed:@"potpos"] forState:UIControlStateNormal];

   potoibtn.layer.cornerRadius=potoibtn.frame.size.width/2;
    [potoibtn addTarget:self action:@selector(poto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:potoibtn];
    [self.view bringSubviewToFront:potoibtn];
    
    

}

-(void)poto{
    
    
    UIAlertController *alerdialog = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"拍照翻译目前只支持英文格式" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的，我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
        _isCiOrJu=YES;
        self.cameraViewvController = [[CameraViewController alloc] init];
        self.cameraViewvController.delegate = self;
        //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        [self presentViewController:self.cameraViewvController animated:YES completion:nil];

        // 操作具体内容
        
        // Nothing to do.
        
    }];
    
 
    [alerdialog addAction:okAction];
    [self presentViewController:alerdialog animated:YES completion:nil];
    
}
    
//    _isCiOrJu=YES;
//    self.cameraViewvController = [[CameraViewController alloc] init];
//    self.cameraViewvController.delegate = self;
//    //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    [self presentViewController:self.cameraViewvController animated:YES completion:nil];
 


//}

//点几语音按钮事件
-(void)yuyinbtn{

     [_shutextview  resignFirstResponder];
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    [_iFlySpeechRecognizer start];
    
    

//    NSLog(@"点击了语音按钮");

}
//翻译按钮
-(void)fanyibtn{

    if (_shutextview.text.length==0) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        _hud.mode = MBProgressHUDModeText;
        _hud.label.text = @"亲，请在文本框输入要翻译的语言！";
        _hud.label.font = [UIFont systemFontOfSize:15];
        
        _hud.label.textColor = [UIColor whiteColor];
        
        _hud.bezelView.color = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
        
        [_hud hideAnimated:YES afterDelay:2.0];

        
//        NSLog(@"不能为空");
        
    }else{
    
      

        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        _hud.mode = MBProgressHUDModeText;
        _hud.label.text = @"正在翻译中....";
        _hud.label.font = [UIFont systemFontOfSize:15];
        
        _hud.label.textColor = [UIColor whiteColor];
        
        _hud.bezelView.color = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];
        
//        [_hud hideAnimated:YES afterDelay:2.0];

     [_shutextview  resignFirstResponder];
//    NSLog(@"发链接开始翻译");
        
        if (_isCiOrJu==NO) {
          [self loadData:_shutextview.text];
        }else{
        
//            NSLog(@"要屌用别的链接解析");
            [self HttpJuZiload:_shutextview.text];
            _isCiOrJu=NO;
        }
        
       
    }
    

}

//键盘上的三个btn点击事件
-(void)keybtn:(UIButton *)btn{


    if (btn.tag==100) {
        _shutextview.text =nil;
//        [_shutextview  resignFirstResponder];
//        NSLog(@"清空");
        
    }if (btn.tag==101) {
        [_shutextview  resignFirstResponder];
//        NSLog(@"取消");
    }if (btn.tag==102) {
        [_shutextview  resignFirstResponder];
//        NSLog(@"发链接开始翻译");
        [self loadData:_shutextview.text];

//        NSLog(@"翻译");
    }
    




}




// 几种常用的代理方法
//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    _shuiproclable.hidden =YES;
//    textView.text = @"";
//    NSLog(@"1");
    return YES;

}

//将要结束编辑
// - (BOOL)textViewShouldEndEditing:(UITextView *)textView;

//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{

//    NSLog(@"2");


}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{

//    return textView.text;
//   NSLog(@"%@",_shutextview.text);

}

//内容将要发生改变编辑
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//// NSLog(@"%@",text);
//    return YES;
////    NSLog(@"%@",text);
//}

//内容发生改变编辑
// - (void)textViewDidChange:(UITextView *)textView;

//焦点发生改变
// - (void)textViewDidChangeSelection:(UITextView *)textView;

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    [_iFlySpeechRecognizer cancel];
    
    if ([text isEqualToString:@"\n"]){
        if (_shutextview.text.length==0) {
            
//            NSLog(@"不能为空");
            
        }else{
        
            [self loadData:_shutextview.text];
          [_shutextview  resignFirstResponder];
//            NSLog(@"发链接开始翻译");
        
        }
        
        
//        NSLog(@"%@",_shutextview.text);
        //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)loadData:(NSString *)text{

    

    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    NSString *utfstr = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSArray *qianar = @[@"zh",@"en",@"jp",@"kor",@"fra",@"ru",@"de"];
    NSArray *houar = @[@"en",@"jp",@"kor",@"fra",@"ru",@"de",@"zh"];
    
    
    
    NSString *urlstr = [NSString stringWithFormat:@"http://fanyi.baidu.com/v2transapi?to=%@&query=%@&from=%@",houar[self.houindex],utfstr,qianar[self.qianindex]];
    //NSLog(@"%@",urlstr);
[manger GET:urlstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    
    
    NSDictionary *dic = responseObject[@"trans_result"];
    NSArray *dataar = dic[@"data"];
    
    for ( NSDictionary *dst in dataar) {
        
      
        _xianshitextview.text = dst[@"dst"];
        
    }
    
    [_hud setHidden:YES];
    
//   NSLog(@"%@",responseObject);
    
//    NSArray *translation = responseObject[@"translation"];
//
////    NSLog(@"%@",translation[0]);
//    _xianshitextview.text = translation[0];

    
    
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
}];

//    [_hud setHidden:YES];
}

//}
-(void)initRecognizer
{
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        _iFlySpeechRecognizer.delegate = self;
//        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
//        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
//    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        
//        //扩展参数
//        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
//        //设置听写模式
//        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//        //设置最长录音时间
//        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
//        //设置后端点
//        [_iFlySpeechRecognizer setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
//        //设置前端点
//        [_iFlySpeechRecognizer setParameter:@"1800" forKey:[IFlySpeechConstant VAD_BOS]];
//        //网络等待时间
//        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
//        //设置采样率，推荐使用16K
//        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
//        //设置语言
//        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
//        //设置方言
//        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
//        //设置是否返回标点符号
////        [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
//        //设置数据返回格式
//  [_iFlySpeechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        
        IATConfig *instance = [IATConfig sharedInstance];
//
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //0无标点返回
        [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
         [_iFlySpeechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    }
}


- (void) onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
//    NSLog(@"%@",resultArray[0]);
    _shuiproclable.hidden = YES;
    
//     _shutextview.text=resultArray[0];
//    [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
////        _shutextview.text = obj;
//   NSLog(@"%@",obj);
//    }];
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = resultArray[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
       
        
         _shutextview.text =resultString;

        
    }

}
//识别会话错误返回
- (void)onError: (IFlySpeechError *) error
{
    //error.errorCode =0 听写正确  other 听写出错
    NSLog(@"错误code=%d",error.errorCode);
    if(error.errorCode!=0){
        //出错
    }
}

- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}


//相机相册库代理回调
-(void)CameraTakePhoto:(UIImage *)image{
//    NSLog(@"111");

    [self recognizeImageWithTesseract:image];


}
//调用ocr显示图片文字
-(void)recognizeImageWithTesseract:(UIImage *)image{
    
    //
//    NSLog(@"222");
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _hud.mode = MBProgressHUDModeText;
    _hud.label.text = @"正在识别文字....";
    _hud.label.font = [UIFont systemFontOfSize:15];
    
    _hud.label.textColor = [UIColor whiteColor];
    
    _hud.bezelView.color = [UIColor colorWithRed:0.12 green:0.78 blue:0.77 alpha:1.0];

    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc]initWithLanguage:@"chi_sim"];

    //
    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    //
    //    // Let Tesseract automatically segment the page into blocks of text
    //    // based on its analysis (see G8Constants.h) for other page segmentation
    //    // mode options
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    //
    //    // Optionally limit the time Tesseract should spend performing the
    //    // recognition
    //    //operation.tesseract.maximumRecognitionTime = 1.0;
    //
    //    // Set the delegate for the recognition to be this class
    //    // (see `progressImageRecognitionForTesseract` and
    //    // `shouldCancelImageRecognitionForTesseract` methods below)
    operation.delegate = self;
    //
    //    // Optionally limit Tesseract's recognition to the following whitelist
    //    // and blacklist of characters
    //    //operation.tesseract.charWhitelist = @"01234";
    //    //operation.tesseract.charBlacklist = @"56789";
    //
    //    // Set the image on which Tesseract should perform recognition
    operation.tesseract.image = image;
    //
    //    // Optionally limit the region in the image on which Tesseract should
    //    // perform recognition to a rectangle
    //    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
    //
    //    // Specify the function block that should be executed when Tesseract
    //    // finishes performing recognition on the image
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
//        NSLog(@"3333");
//        NSLog(@"%@", recognizedText);
        _shuiproclable.hidden = YES;
        _shutextview.text = recognizedText;
         [_hud setHidden:YES];
//        _hud.isHidden =YES;
        
    };
    [self.operationQueue addOperation:operation];
}

-(void)HttpJuZiload:(NSString *)text{

    HttpManager *manger = [HttpManager shareManager];

    NSString *utfstr = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@",utfstr);
    NSString *str =[NSString stringWithFormat:@"http://118.190.24.201/itranslator/tk.php?text=%@",utfstr];
    
  [manger requestWithUrl:str withDictionary:nil withSuccessBlock:^(id responseObject) {
      NSData *datga =responseObject;
     NSString *string = [[NSString alloc] initWithData:datga encoding:NSUTF8StringEncoding];
      [self ChanglianjieHttp:string];
//      NSLog(@"%@",string);
      
  } withFailureBlock:^(NSError *error) {
//      NSLog(@"%@",error);
  }];

//    _hud.hidden = YES;
    
    
}
-(void)ChanglianjieHttp:(NSString *)Str{

    HttpManager *manger = [HttpManager shareManager];
    
    NSString *utfstr = [_shutextview.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",utfstr);
    
    
    NSString *str =[NSString stringWithFormat:@"http://translate.google.cn/translate_a/t?client=webapp&sl=en&tl=zh-CN&hl=zh-CN&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&source=btn&ssel=0&tsel=0&kc=0&tk=%@&q=%@",Str,utfstr];
    
    [manger requestWithUrl:str withDictionary:nil withSuccessBlock:^(id responseObject) {
        NSData *datga =responseObject;
        NSString *string = [[NSString alloc] initWithData:datga encoding:NSUTF8StringEncoding];
        string = [string stringByReplacingOccurrencesOfString:@"|n" withString:@"n"];
        _xianshitextview.text = [NSString stringWithFormat:@"%@",string];
//          NSLog(@"%@",string);
     [_hud setHidden:YES];
    } withFailureBlock:^(NSError *error) {
              NSLog(@"%@",error);
    }];




}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }


@end
