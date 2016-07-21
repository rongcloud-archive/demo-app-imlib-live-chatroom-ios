# 直播聊天室 SDK 及 Demo 源码说明


## 下载地址

http://www.rongcloud.cn/live

* 下载的SDK，包含RongIMToolkit 和 RongIMLib(这里和普通的融云SDK中的RongIMLib一致，如官网有更新请用官网最新版本替换) ，以及表情Emoji配置文件、资源包、本地化文件
* 下载的Demo源码，需要引入以上SDK

## 源码说明

* Demo 源码默认集成了金山视频播放器 （引入 KSYMediaPlayer.Framework），如使用其他直播请自行替换。

* Demo 登录页面LoginViewController 中登录融云的操作，为了演示直接在客户端请求融云的服务器获取token然后登录，实际开发中需要通过您的服务器来融云获取token，这样更安全，不易泄露您的APP的APPSECRET 和 APPKEY。（请将Demo源码中Common目录下的RCKitCommonDefine.h中的 RONGCLOUD_IM_APPKEY 和RONGCLOUD_IM_APPSECRET 替换成您自己在融云后台注册的。）

* demo 中与融云SDK 交互主要是调用 RongIMLib.framework 里 RCIMCliet.h 中的接口。接口相关说明请参考 http://www.rongcloud.cn/docs/ios_imlib.html


## 操作步骤

* 获取到token 之后调用RongIMLib.framework 里 RCIMCliet.h 中 connectWithToken 方法登录融云。

* 进入聊天室需要调用RongIMLib.framework 里 RCIMCliet.h 中的 joinChatRoom 接口加入聊天室，退出的时候调用quitChatRoom。

* 发送消息请参考Demo 中调用的sendMessage 方法。

* 接收消息可以通过设置实现 RCIMClient 里的代理 RCIMClientReceiveMessageDelegate 实现 onReceived 方法。（参考 Demo 源码中 RCIM.m ）

* ChatroomVC目录下是直播聊天室的页面，此Demo 实现了文本消息和小灰条提示消息，以及送鲜花的消息，开发者可以参考源码实现任意扩展自己的消息（关于自定义消息请参考http://www.rongcloud.cn/docs/ios.html#自定义消息_Cell和http://www.rongcloud.cn/docs/ios_imlib.html#自定义消息）。


其他部分请参考 http://www.rongcloud.cn/docs
