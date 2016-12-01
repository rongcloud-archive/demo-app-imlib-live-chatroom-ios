//
//  RCEmojiBoardView.m
//  RCIM
//
//  Created by Heq.Shinoda on 14-5-29.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDLiveEmojiBoardView.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveEmojiPageControl.h"

#define RC_EMOJI_WIDTH 32
#define RC_EMOTIONTAB_SIZE_HEIGHT 42
#define RC_EMOTIONTAB_SIZE_WIDTH 42
#define RC_EMOTIONTAB_ICON_SIZE 25


@interface RCDLiveEmojiBoardView ()

@property(nonatomic, assign) int emojiTotal;
@property(nonatomic, assign) int emojiTotalPage;
@property(nonatomic, assign) int emojiColumn;
@property(nonatomic, assign) int emojiRow;
@property(nonatomic, assign) int emojiMaxCountPerPage;
@property(nonatomic, assign) CGFloat emojiMariginHorizontalMin;
@property(nonatomic, assign) CGFloat emojiSpanVertial;
@property(nonatomic, assign) CGFloat emojiSpanHorizontal;
@property(nonatomic, strong) NSArray *faceEmojiArray;
@property(nonatomic, assign) int emojiLoadedPage;
@property(nonatomic,strong)UIView *tabbarView;
@property(nonatomic,assign)CGSize emojiContentSize;//默认的emoji 的contentSize

@property(nonatomic, strong) NSMutableArray *tabIconArray;//tabIconArray 中包含的表情tab 按钮 比 emojiModelList 多1个，emojiModeList 中不包含emoji字符串表情
//
///**
// * 表情Icon容器，每个表情包的Icon 都放到这里,用于点击切换表情包展示
// */
@property(nonatomic, strong) UIScrollView *emotionTabView;

/*!
 自定义表情的 Model 数组
 */
@property(nonatomic, strong) NSMutableArray *emojiModelList;

@end

@implementation RCDLiveEmojiBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *bundlePath = [resourcePath stringByAppendingPathComponent:@"Emoji.plist"];
        RCDLive_DebugLog(@"Emoji.plist > %@", bundlePath);
        self.faceEmojiArray = [[NSArray alloc]initWithContentsOfFile:bundlePath];
        self.emojiLoadedPage = 0;
        
        [self generateDefaultLayoutParameters];

        self.emojiBackgroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 186.5)];
        self.emojiBackgroundView.backgroundColor = RCDLive_HEXCOLOR(0xf8f8f8);
        self.emojiBackgroundView.pagingEnabled = YES;
        self.emojiBackgroundView.contentSize = CGSizeMake(self.emojiTotalPage * self.frame.size.width, 186.5);
        self.emojiBackgroundView.showsHorizontalScrollIndicator = NO;
        self.emojiBackgroundView.showsVerticalScrollIndicator = NO;
        self.emojiBackgroundView.delegate = self;
        [self addSubview:self.emojiBackgroundView];
        
        [self loadLabelView];
    }
    return self;
}

- (void)generateDefaultLayoutParameters {
    self.emojiSpanHorizontal = 47;
    self.emojiSpanVertial = 42;
    self.emojiRow = 3;
    self.emojiMariginHorizontalMin = 6;
    if (nil == self.faceEmojiArray ||  [self.faceEmojiArray count] == 0) {
        self.emojiTotal = 0;
    }else{
        self.emojiTotal = (int)[self.faceEmojiArray count]; //sizeof(faceEmojiArray) / sizeof(faceEmojiArray[0]); //(int)[self.faceEmojiArray count];//
    }
    self.emojiColumn = (int)self.frame.size.width / self.emojiSpanVertial;
    int left = (int)self.frame.size.width % 44;
    if (left < 12) {
        self.emojiColumn--;
        left += self.emojiSpanVertial;
    }
    self.emojiMaxCountPerPage = self.emojiColumn * self.emojiRow - 1;
    self.emojiMariginHorizontalMin = left / 2;
    self.emojiTotalPage =
        self.emojiTotal / self.emojiMaxCountPerPage + (self.emojiTotal % self.emojiMaxCountPerPage ? 1 : 0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)loadLabelView {
    [self loadEmojiViewPartly];

    if (!pageCtrl) {
        pageCtrl = [[RCDLiveEmojiPageControl alloc] initWithFrame:CGRectMake(0,175, self.frame.size.width, 5)];
        pageCtrl.numberOfPages = self.emojiTotalPage; //总的图片页数
        pageCtrl.currentPage = 0;                     //当前页
        [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageCtrl];
    }
    
    _tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 42, self.frame.size.width, 42)];
//    _tabbarView.backgroundColor = [RCTK sharedRCTK].theme.emojiTabViewColor;
    [self addSubview:_tabbarView];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.tag = 333;
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    sendBtn.frame = CGRectMake(self.frame.size.width - 52,9,52, 34);
    [sendBtn setTitle:NSLocalizedStringFromTable(@"Send", @"RongCloudKit", nil) forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:sendBtn];
    [self loadCustomerEmoticonPackage];
}

- (void)enableSendButton:(BOOL)sender{
    UIButton *sendButton = (UIButton *)[self viewWithTag:333];
    if (sender) {
        sendButton.userInteractionEnabled = YES;
        sendButton.backgroundColor = RCDLive_HEXCOLOR(0x0099ff);
        [sendButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        sendButton.userInteractionEnabled = NO;
        sendButton.backgroundColor = RCDLive_HEXCOLOR(0xfafafa);
        [sendButton  setTitleColor:RCDLive_HEXCOLOR(0x999999) forState:UIControlStateNormal];
    }
    
}

//延迟加载
- (void)loadEmojiViewPartly {
    //每次加载两页，防止快速移动
    int beginEmojiBtn = self.emojiLoadedPage * self.emojiMaxCountPerPage;
    int endEmojiBtn = MIN(self.emojiTotal, (self.emojiLoadedPage + 2) * self.emojiMaxCountPerPage);
    float startPos_X = 19, startPos_Y = 26.5;
    int emojiSpanHorizontalcount = ([UIScreen mainScreen].bounds.size.width - 15*2+12)/(30+12);
    startPos_X = ([UIScreen mainScreen].bounds.size.width - emojiSpanHorizontalcount*42+12)/2;
    for (int i = beginEmojiBtn; i < endEmojiBtn; i++) {
        int pageIndex = i / self.emojiMaxCountPerPage;
        float emojiPosX = startPos_X + 42 * (i % self.emojiMaxCountPerPage % self.emojiColumn)+
                          pageIndex * self.frame.size.width;
        float emojiPosY = startPos_Y + 47 * (i % self.emojiMaxCountPerPage / self.emojiColumn);
        UIButton *emojiBtn =
            [[UIButton alloc] initWithFrame:CGRectMake(emojiPosX, emojiPosY, RC_EMOJI_WIDTH, RC_EMOJI_WIDTH)];
        emojiBtn.titleLabel.font = [UIFont systemFontOfSize:28];
    
       // NSString *emoji_ =
       // NSLog(@"<string>%@</string>", faceEmojiArray[i]);
        [emojiBtn setTitle:self.faceEmojiArray[i] forState:UIControlStateNormal];
        [emojiBtn addTarget:self action:@selector(emojiBtnHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self.emojiBackgroundView addSubview:emojiBtn];
        
        if (((i + 1) >= self.emojiMaxCountPerPage && (i + 1) % self.emojiMaxCountPerPage == 0) ||
            i == self.emojiTotal - 1) {
            CGRect frame = emojiBtn.frame;
            UIButton *deleteButton =
                [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton addTarget:self
                             action:@selector(emojiBtnHandle:)
                   forControlEvents:UIControlEventTouchUpInside];
            frame.origin.x =
                self.frame.size.width - startPos_X - 30 + pageIndex * self.frame.size.width;
            frame.size = CGSizeMake(RC_EMOJI_WIDTH, RC_EMOJI_WIDTH);
            deleteButton.frame = frame;
            [deleteButton setImage:RCDLive_IMAGE_BY_NAMED(@"emoji_btn_delete") forState:UIControlStateNormal];
            deleteButton.contentEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
            [self.emojiBackgroundView addSubview:deleteButton];
        }
        if (self.emojiLoadedPage < pageIndex + 1) {
            self.emojiLoadedPage = pageIndex + 1;
        }
    }
    self.emojiContentSize = self.emojiBackgroundView.contentSize;
}

-(void)loadCustomerEmoticonPackage{

    if (_tabIconArray) {
        [_tabIconArray removeAllObjects];
    }else{
        _tabIconArray = [NSMutableArray new];
    }
    int emotionnTabViewMaxWidth = self.frame.size.width- 80;
    int emotionPackageNum = (int)_emojiModelList.count; // 表情包数量
    int emotionTabViewWidth = (RC_EMOTIONTAB_SIZE_WIDTH) * (emotionPackageNum+1);//加上emoji的位置和加号位置
    if(emotionTabViewWidth>emotionnTabViewMaxWidth)
        emotionTabViewWidth= emotionnTabViewMaxWidth;
    if (self.emotionTabView) {
        [self.emotionTabView removeFromSuperview];
    }
    self.emotionTabView = [[UIScrollView alloc]initWithFrame:CGRectMake(RC_EMOTIONTAB_SIZE_WIDTH * 0 +5, 0, emotionTabViewWidth, 42)];//暂时不显示加号，所以位置前移
    self.emotionTabView.backgroundColor = [UIColor clearColor];
    self.emotionTabView.contentSize = CGSizeMake((RC_EMOTIONTAB_SIZE_WIDTH) * (_emojiModelList.count+1), 42);
    self.emotionTabView.pagingEnabled =YES;
    self.emotionTabView.showsVerticalScrollIndicator = FALSE;
    self.emotionTabView.showsHorizontalScrollIndicator = FALSE;
    [_tabbarView addSubview:self.emotionTabView];
    UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiBtn.backgroundColor = RCDLive_HEXCOLOR(0xf8f8f8);
    emojiBtn.frame = CGRectMake(0,5, 45, 37);
    [emojiBtn setImage:RCDLive_IMAGE_BY_NAMED(@"emoji_btn_normal") forState:UIControlStateNormal];
    emojiBtn.contentEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12);
    [emojiBtn addTarget:self action:@selector(tabBtnHandle:) forControlEvents:UIControlEventTouchUpInside];

    [self.emotionTabView addSubview:emojiBtn];
    [_tabIconArray addObject:emojiBtn];
    
}
- (void)emojiBtnHandle:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didTouchEmojiView:touchedEmoji:)]) {
        [self.delegate didTouchEmojiView:self touchedEmoji:sender.titleLabel.text];
    }
}

- (void)sendBtnHandle:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSendButtonEvent)]) {
        [self.delegate didSendButtonEvent];
    }
}

- (void)tabBtnHandle:(UIButton *)sender {
    for (int i = 0;i < self.tabIconArray.count;i++) {
        UIButton *btn = self.tabIconArray[i];
        int selectIndex = i;
        //tabIconArray 中包含的表情tab 按钮 比 emojiModelList 多1个，emojiModeList 中不包含emoji字符串表情
        if (sender == btn) {
            btn.backgroundColor = RCDLive_HEXCOLOR(0xf8f8f8);
            CGSize viewSize = self.emojiBackgroundView.frame.size;
            CGRect rect = CGRectMake(selectIndex * viewSize.width, 0, viewSize.width, viewSize.height);
            [self.emojiBackgroundView scrollRectToVisible:rect animated:NO];
            [pageCtrl setCurrentPage:0];

        }else{
            btn.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self loadEmojiViewPartly];
}

//停止滚动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    int currentIndex = offset.x / bounds.size.width;
    pageCtrl.numberOfPages = self.emojiTotalPage;
    for (UIButton *btn in self.tabIconArray) {
        btn.backgroundColor = [UIColor clearColor];
    }
    UIButton *tabBtn = self.tabIconArray[0];
    tabBtn.backgroundColor = RCDLive_HEXCOLOR(0xf8f8f8);
    pageCtrl.numberOfPages = self.emojiTotalPage;
    [pageCtrl setCurrentPage:currentIndex];
    RCDLive_DebugLog(@"%f", offset.x / bounds.size.width);
}

//然后是点击UIPageControl时的响应函数pageTurn
- (void)pageTurn:(UIPageControl *)sender {
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = self.emojiBackgroundView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [self.emojiBackgroundView scrollRectToVisible:rect animated:YES];
}

- (float) getBoardViewBottonOriginY{
    float gap = (RCDLive_IOS_FSystenVersion < 7.0) ? 64 : 0 ;
    return [UIScreen mainScreen].bounds.size.height - gap;
}
//用于动画效果
- (void)setHidden:(BOOL)hidden {
    CGRect viewRect = self.frame;
    if (hidden) {
        viewRect.origin.y = [self getBoardViewBottonOriginY];
    } else {
        viewRect.origin.y = [self getBoardViewBottonOriginY] - self.frame.size.height;
    }
    [self setFrame:viewRect];
    [super setHidden:hidden];
}


@end
