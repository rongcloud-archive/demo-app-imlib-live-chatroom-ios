//
//  ViewController.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/4/6.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "LoginViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDLiveChatRoomViewController.h"
#import "RCDLiveKitCommonDefine.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "RCDLive.h"


@interface LoginViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITextView *idTextField;
@property (nonatomic,strong)UITextView *nameTextField;
@property (nonatomic,strong)UITextView *chatRoomTextField;
@property (nonatomic,strong)UITextView *channelTextField;
@property (nonatomic,strong)UISwitch *modeSwitch;
@property (nonatomic,strong)UIButton *loginForLiveButton;
@property (nonatomic,strong)UIButton *loginForTVButton;
/*!
 屏幕方向
 */
@property(nonatomic, assign) BOOL isScreenVertical;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:@"bg"];
    self.view.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    _isScreenVertical = YES;
    CGRect viewSize=self.view.bounds;
    [self setupLoadView];
    
    UILabel *selectLiveSourceLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewSize.size.width - 100)/2,280,100,40)];
    [selectLiveSourceLabel setText:@"选择直播源"];
    selectLiveSourceLabel.textAlignment = NSTextAlignmentCenter;
    selectLiveSourceLabel.textColor = RCDLive_HEXCOLOR(0x00aeff);
    [self.view addSubview:selectLiveSourceLabel];
    _loginForTVButton=[[UIButton alloc]initWithFrame:CGRectMake((viewSize.size.width - 160)/2, 340,160, 40)];
    [_loginForTVButton setImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    _loginForTVButton.backgroundColor=[UIColor clearColor];
  
    [_loginForTVButton addTarget:self action:@selector(loginRongCloudForTV) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginForTVButton];
  // 创建label
    UILabel *tvButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(_loginForTVButton.frame.size.width/2 -20 ,0,40,40)];
    [tvButtonLabel setText:@"电视"];
    tvButtonLabel.textColor = RCDLive_HEXCOLOR(0x00aeff);
    tvButtonLabel.textAlignment = NSTextAlignmentCenter;
    [_loginForTVButton addSubview:tvButtonLabel];
    _loginForLiveButton=[[UIButton alloc]initWithFrame:CGRectMake((viewSize.size.width - 160)/2 , 400,160, 40)];
    [_loginForLiveButton setImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    _loginForLiveButton.tintColor = RCDLive_HEXCOLOR(0x00aeff);
    _loginForLiveButton.backgroundColor=[UIColor clearColor];
    [_loginForLiveButton addTarget:self action:@selector(loginRongCloudForLive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginForLiveButton];
    UILabel *liveButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake((_loginForLiveButton.frame.size.width - 40)/2,0,40,40)];
    [liveButtonLabel setText:@"主播"];
    liveButtonLabel.textAlignment = NSTextAlignmentCenter;
    liveButtonLabel.textColor = RCDLive_HEXCOLOR(0x00aeff);
    [_loginForLiveButton addSubview:liveButtonLabel];
}

- (void)setupLoadView{
    CGSize srceenSize = self.view.bounds.size;
  
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((srceenSize.width - 100)/2, 150,100 , 100)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
//    self.idTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50,170,srceenSize.width - 100,50)];
//    self.idTextField.backgroundColor = [UIColor clearColor];
//    
//    //账号
//    UIColor* color = [UIColor whiteColor];
//    self.idTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{ NSForegroundColorAttributeName : color }];
//    self.idTextField.textColor = [UIColor whiteColor];
//    self.idTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.view addSubview:self.idTextField];
//    
//    //昵称
//    self.nameTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50, 240,srceenSize.width - 100, 50)];
//    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"昵称" attributes:@{ NSForegroundColorAttributeName : color }];
//    self.nameTextField.textColor = [UIColor whiteColor];
//    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.nameTextField addTarget:self
//                        action:@selector(textFieldDidChange:)
//              forControlEvents:UIControlEventEditingChanged];
//    [self.view addSubview:self.nameTextField];
//    
//    //聊天室Id
//    self.chatRoomTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50, 310,srceenSize.width - 100, 50)];
//    self.chatRoomTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"聊天室Id" attributes:@{ NSForegroundColorAttributeName : color }];
//    self.chatRoomTextField.textColor = [UIColor whiteColor];
//    self.chatRoomTextField.text = @"ChatRoom01";
//    self.chatRoomTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.view addSubview:self.chatRoomTextField];
//    
//    //视频源地址
//    self.channelTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50, 380,srceenSize.width - 100, 50)];
//    self.channelTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"视频源" attributes:@{ NSForegroundColorAttributeName : color }];
//    self.channelTextField.textColor = [UIColor whiteColor];
//
//    self.channelTextField.text = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";//rtmp://vlive3.rtmp.cdn.ucloud.com.cn/ucloud/8616
//    self.channelTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [self.view addSubview:self.channelTextField];
//    
//    UILabel *portraitUriLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,440,90,40)];
//    portraitUriLabel.text = @"全屏模式 :";
//    [portraitUriLabel setTextColor:[UIColor whiteColor]];
//    portraitUriLabel.textAlignment = NSTextAlignmentRight;
//    [self.view addSubview:portraitUriLabel];
//    self.modeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(srceenSize.width - 100, 440, 180, 40)];
//    //    [self.modeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.modeSwitch];
  
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
//        self.idTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
//    }
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
//        self.nameTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
//    }
  
    UITapGestureRecognizer *resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [resetBottomTapGesture setDelegate:self];
    [self.view addGestureRecognizer:resetBottomTapGesture];
}


-(void)loginRongCloudForTV{
  [self loginRongCloud:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
}

-(void)loginRongCloudForLive{
  [self loginRongCloud:@"rtmp://vlive3.rtmp.cdn.ucloud.com.cn/ucloud/8971"];
}

/**
 *登录融云，这里只是为了演示所以直接调融云的server接口获取token来登录，为了您的app安全，这里建议您通过你们自己的服务端来获取token。
 *
 */
-(void)loginRongCloud:(NSString *)videoUrl
{
    _loginForTVButton.enabled = NO;
    _loginForLiveButton.enabled = NO;
    NSString *userId = self.idTextField.text;
    NSString *userName = self.nameTextField.text;
    NSString *userProtrait = @"";
  
    userId = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];

    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    int x = arc4random() % 6;
    RCUserInfo *user =(RCUserInfo*)app.userList[x];
    userName = user.name;
    userProtrait = user.portraitUri;
    NSDictionary *params = @{@"userId":userId, @"name":userName, @"protraitUrl":userProtrait};
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中...";
    
    NSString *url = @"http://api.cn.ronghub.com/user/getToken.json";
    //获得请求管理者
    AFHTTPRequestOperationManager* mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *nonce = [NSString stringWithFormat:@"%d", rand()];
    
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];
    
    NSString *unionString = [NSString stringWithFormat:@"%@%@%ld", RONGCLOUD_IM_APPSECRET, nonce, timestamp];
    const char *cstr = [unionString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:unionString.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
    NSString *timestampStr = [NSString stringWithFormat:@"%ld", timestamp];
    [mgr.requestSerializer setValue:RONGCLOUD_IM_APPKEY forHTTPHeaderField:@"App-Key"];
    [mgr.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [mgr.requestSerializer setValue:timestampStr forHTTPHeaderField:@"Timestamp"];
    [mgr.requestSerializer setValue:output forHTTPHeaderField:@"Signature"];
    __weak __typeof(&*self)weakSelf = self;
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
          NSLog(@"success");
          NSNumber *code = responseObj[@"code"];
          if (code.intValue == 200) {
              NSString *token = responseObj[@"token"];
              NSString *userId = responseObj[@"userId"];
              
              [[RCDLive sharedRCDLive] connectRongCloudWithToken:token success:^(NSString *loginUserId) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      RCUserInfo *user = [[RCUserInfo alloc]init];
                      user.userId = userId;
                      user.portraitUri = userProtrait;
                      user.name = userName;
                      [RCIMClient sharedRCIMClient].currentUserInfo = user;
                      RCDLiveChatRoomViewController *chatRoomVC = [[RCDLiveChatRoomViewController alloc]init];
                      chatRoomVC.conversationType = ConversationType_CHATROOM;
                      chatRoomVC.targetId = @"ChatRoom01";
                      chatRoomVC.contentURL = videoUrl;
                      chatRoomVC.isScreenVertical = _isScreenVertical;
                      [self.navigationController setNavigationBarHidden:YES];
                      [self.navigationController pushViewController:chatRoomVC animated:NO];
                      
                  });
              } error:^(RCConnectErrorCode status) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                    _loginForTVButton.enabled = YES;
                    _loginForLiveButton.enabled = YES;
                  });
                  
              } tokenIncorrect:^{
                  dispatch_async(dispatch_get_main_queue(), ^{
                    _loginForTVButton.enabled = YES;
                    _loginForLiveButton.enabled = YES;
                  });
              }];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                _loginForTVButton.enabled = YES;
                _loginForLiveButton.enabled = YES;
              });
              
          } else {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                _loginForTVButton.enabled = YES;
                _loginForLiveButton.enabled = YES;
              });
          }
          
      } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
          NSLog(@"error");
          dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            _loginForTVButton.enabled = YES;
            _loginForLiveButton.enabled = YES;
          });
      }];
  
}

- (void)textFieldDidChange:(UITextField *)textField {
  if ([textField.text isEqualToString:@"xiaoqiao"]) {
    [[RCIMClient sharedRCIMClient] connectWithToken:self.idTextField.text success:^(NSString *loginUserId) {
      dispatch_async(dispatch_get_main_queue(), ^{
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = loginUserId;
        user.portraitUri = @"";
        user.name = loginUserId;
        [RCIMClient sharedRCIMClient].currentUserInfo = user;
        RCDLiveChatRoomViewController *chatRoomVC = [[RCDLiveChatRoomViewController alloc]init];
        chatRoomVC.conversationType = ConversationType_CHATROOM;
        chatRoomVC.targetId = self.chatRoomTextField.text;
        chatRoomVC.contentURL = self.channelTextField.text;
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:chatRoomVC animated:NO];
        
      });
    } error:^(RCConnectErrorCode status) {
      dispatch_async(dispatch_get_main_queue(), ^{
        _loginForTVButton.enabled = YES;
        _loginForLiveButton.enabled = YES;
      });
      
    } tokenIncorrect:^{
      dispatch_async(dispatch_get_main_queue(), ^{
        _loginForTVButton.enabled = YES;
        _loginForLiveButton.enabled = YES;
      });
    }];
  }
}

- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  屏幕翻转
 *
 *  @param newCollection <#newCollection description#>
 *  @param coordinator   <#coordinator description#>
 */
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection
                 withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
     {
         if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
             //To Do: modify something for compact vertical size
             _isScreenVertical = NO;
         } else {
             _isScreenVertical = YES;
             //To Do: modify something for other vertical size
         }
         [self.view setNeedsLayout];
     } completion:nil];
}
@end
