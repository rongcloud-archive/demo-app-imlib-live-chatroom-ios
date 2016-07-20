//
//  UCloudMediaPlayer.h
//

#import <Foundation/Foundation.h>
#import "UCloudMediaPlayback.h"

typedef NS_ENUM(NSInteger, DecodeMthod)
{
    DecodeMthodSoft,//软解
    DecodeMthodHard,//硬解
};

typedef NS_ENUM(NSInteger, Definition)
{
    Definition_fhd,   //@"蓝光"
    Definition_shd,   //@"超清"
    Definition_hd,    //@"高清"
    Definition_sd,    //@"标清"
};

typedef NS_ENUM(NSInteger, ErrorNum)
{
    ErrorNumShowViewIsNull = 1000,
    ErrorNumUrlIsNull,
    ErrorNumSaveShotError,
    ErrorNumUrlIsWrong,
    ErrorNumdrm,
    
    ErrorNumCgiLostPars = 40021,
    ErrorNumCgiRequest = 40022,
    ErrorNumCgiAuthFail = 40023,
    ErrorNumCgiMovieCannotFound = 40024,//不会构建videoview
    ErrorNumCgiDomainError = 40025,
    ErrorNumCgiServerError = 40026,
    ErrorNumCgiTimeOut = 40027,
};

typedef NS_ENUM(NSInteger, UrlType)
{
    UrlTypeAuto   = 0,//自动，程序会根据相关规则为你选择播放类型，如果是http-flv直播，请必须设置为UrlTypeLive
    UrlTypeLocal  = 1,//本地视频
    UrlTypeHttp   = 2,//网络视频(非直播)
    UrlTypeLive   = 3,//直播
};

typedef void(^UCloudMediaCompletionBlock)(NSInteger defaultNum, NSArray *data);

@interface UCloudMediaPlayer : NSObject

/**
 *  画面填充方式
 */
@property (assign, nonatomic) MPMovieScalingMode    defaultScalingMode;

/**
 *  默认的解码方式
 */
@property (assign, nonatomic) DecodeMthod           defaultDecodeMethod;

/**
 *  播放地址
 */
@property (strong, nonatomic) NSURL                 *url;

/**
 *  视频来源
 */
@property (assign, nonatomic) UrlType               urlType;

/**
 *  播放器控制器
 */
@property (strong, nonatomic) id<UCloudMediaPlayback> player;

/**
 *  初始化mediaPlayer
 *
 *  @return UCloudMediaPlayer
 */
+ (instancetype)ucloudMediaPlayer;

/**
 *  配置播放view
 *
 *  @param url   播放url
 *  @param urltype 播放类型
 *  @param frame playerView视图大小，默认传入CGRectNull
 *  @param view  player
 *  @param block 初始化完成
 */
- (void)showMediaPlayer:(NSString *)url urltype:(UrlType)urltype frame:(CGRect)frame view:(UIView *)view completion:(UCloudMediaCompletionBlock)block;

/**
 *  配置播放view
 *
 *  @param view  父view
 *  @param block 回掉清晰度信息
 */
- (void)showInview:(UIView *)view definition:(void(^)(NSInteger defaultNum, NSArray *data))block;

/**
 *  切换解码方式
 *
 *  @param decode 切换后的解码方式
 */
- (void)selectDecodeMthod:(DecodeMthod)decode;

/**
 *  切换清晰度
 *
 *  @param definition 切换后的清晰度
 */
- (void)selectDefinition:(Definition)definition;

/**
 *  刷新视图
 */
- (void)refreshView;

@end
