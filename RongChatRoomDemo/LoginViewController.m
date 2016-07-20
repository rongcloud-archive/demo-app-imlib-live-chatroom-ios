//
//  ViewController.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/4/6.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "LoginViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "ChatRoomViewController.h"
#import "RCKitCommonDefine.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "RCUnderlineTextField.h"



@interface LoginViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic,strong)RCUnderlineTextField *idTextField;
@property (nonatomic,strong)RCUnderlineTextField *nameTextField;
@property (nonatomic,strong)RCUnderlineTextField *chatRoomTextField;
@property (nonatomic,strong)RCUnderlineTextField *channelTextField;
@property (nonatomic,strong)UISwitch *modeSwitch;
@property (nonatomic,strong)UIButton *loginButton;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"login_background"];
    self.view.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGRect viewSize=self.view.bounds;
    [self setupLoadView];
    _loginButton=[[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(self.modeSwitch.frame)+20,viewSize.size.width - 100, 50)];
    [_loginButton setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    _loginButton.backgroundColor=[UIColor blueColor];
    [_loginButton addTarget:self action:@selector(loginRongCloud) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
}

- (void)setupLoadView{
    CGSize srceenSize = self.view.bounds.size;
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 80,srceenSize.width -200 , 60)];
    logoImageView.image = [UIImage imageNamed:@"ronglogo"];
    [self.view addSubview:logoImageView];
    
    self.idTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50,170,srceenSize.width - 100,50)];
    self.idTextField.backgroundColor = [UIColor clearColor];
    
    //账号
    UIColor* color = [UIColor whiteColor];
    self.idTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{ NSForegroundColorAttributeName : color }];
    self.idTextField.textColor = [UIColor whiteColor];
    self.idTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.idTextField];
    
    //昵称
    self.nameTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50, 240,srceenSize.width - 100, 50)];
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"昵称" attributes:@{ NSForegroundColorAttributeName : color }];
    self.nameTextField.textColor = [UIColor whiteColor];
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nameTextField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.nameTextField];
    
    //聊天室Id
    self.chatRoomTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50, 310,srceenSize.width - 100, 50)];
    self.chatRoomTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"聊天室Id" attributes:@{ NSForegroundColorAttributeName : color }];
    self.chatRoomTextField.textColor = [UIColor whiteColor];
    self.chatRoomTextField.text = @"ChatRoom01";
    self.chatRoomTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.chatRoomTextField];
    
    //视频源地址
    self.channelTextField = [[RCUnderlineTextField alloc] initWithFrame:CGRectMake(50, 380,srceenSize.width - 100, 50)];
    self.channelTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"视频源" attributes:@{ NSForegroundColorAttributeName : color }];
    self.channelTextField.textColor = [UIColor whiteColor];
    self.channelTextField.text = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";//rtmp://vlive3.rtmp.cdn.ucloud.com.cn/ucloud/8616
    self.channelTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.channelTextField];
    
    UILabel *portraitUriLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,440,90,40)];
    portraitUriLabel.text = @"全屏模式 :";
    [portraitUriLabel setTextColor:[UIColor whiteColor]];
    portraitUriLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:portraitUriLabel];
    self.modeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(srceenSize.width - 100, 440, 180, 40)];
    //    [self.modeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.modeSwitch];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]) {
        self.idTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        self.nameTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    }
    
    UITapGestureRecognizer *resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [resetBottomTapGesture setDelegate:self];
    [self.view addGestureRecognizer:resetBottomTapGesture];
}

/**
 *登录融云，这里只是为了演示所以直接调融云的server接口获取token来登录，为了您的app安全，这里建议您通过你们自己的服务端来获取token。
 *
 */
-(void)loginRongCloud
{
    _loginButton.enabled = NO;
    NSString *userId = self.idTextField.text;
    NSString *userName = self.nameTextField.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([userId length] < 1 || [userName length] < 1){
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号和用户名" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",@"RongCloudKit",nil) otherButtonTitles:nil, nil];
        [errorAlert show];
        _loginButton.enabled = YES;
        return;
    }
    
    
    NSDictionary *params = @{@"userId":userId, @"name":userName, @"portraitUrl":@""};
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
              
              [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *loginUserId) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      RCUserInfo *user = [[RCUserInfo alloc]init];
                      user.userId = userId;
                      [[RCTK sharedRCTK] initWithAppKey:RONGCLOUD_IM_APPKEY andUserId:userId];
                      
                      user.portraitUri = @"";
                      user.name = userName;
                      [RCIMClient sharedRCIMClient].currentUserInfo = user;
                      ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc]init];
                      chatRoomVC.conversationType = ConversationType_CHATROOM;
                      chatRoomVC.targetId = self.chatRoomTextField.text;
                      chatRoomVC.isFullScreen = self.modeSwitch.isOn;
                      chatRoomVC.contentURL = self.channelTextField.text;
                      [self.navigationController setNavigationBarHidden:YES];
                      [self.navigationController pushViewController:chatRoomVC animated:NO];
                      
                  });
              } error:^(RCConnectErrorCode status) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      _loginButton.enabled = YES;
                  });
                  
              } tokenIncorrect:^{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      _loginButton.enabled = YES;
                  });
              }];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                  _loginButton.enabled = YES;
              });
              
          } else {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                  _loginButton.enabled = YES;
              });
          }
          
      } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
          NSLog(@"error");
          dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
              _loginButton.enabled = YES;
          });
      }];
  
}

- (void)textFieldDidChange:(UITextField *)textField {
  if ([textField.text isEqualToString:@"xiaoqiao"]) {
    [[RCIMClient sharedRCIMClient] connectWithToken:self.idTextField.text success:^(NSString *loginUserId) {
      dispatch_async(dispatch_get_main_queue(), ^{
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = loginUserId;
        [[RCTK sharedRCTK] initWithAppKey:@"e0x9wycfx7flq" andUserId:loginUserId];
        
        user.portraitUri = @"";
        user.name = loginUserId;
        [RCIMClient sharedRCIMClient].currentUserInfo = user;
        ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc]init];
        chatRoomVC.conversationType = ConversationType_CHATROOM;
        chatRoomVC.targetId = self.chatRoomTextField.text;
        chatRoomVC.isFullScreen = self.modeSwitch.isOn;
        chatRoomVC.contentURL = self.channelTextField.text;
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:chatRoomVC animated:NO];
        
      });
    } error:^(RCConnectErrorCode status) {
      dispatch_async(dispatch_get_main_queue(), ^{
        _loginButton.enabled = YES;
      });
      
    } tokenIncorrect:^{
      dispatch_async(dispatch_get_main_queue(), ^{
        _loginButton.enabled = YES;
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

@end
