

#import "ADmuingDMManager.h"
#import "ADmuingDMContainerView.h"
#import "ADmuingDMView.h"
#import "ADmuingDMRequest.h"
#import <AdSupport/AdSupport.h>

#define DM_COMMENTS_URL @"http://api.admuing.com/danmakuList"

@interface ADmuingDMManager(){
    ADmuingDMContainerView* _dm_container;
    ADmuingDMRequest *_dmCommentsRequest;
    BOOL _isShow;  //是否正展示
}

@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSTimer *timer;
@end

static ADmuingDMManager* _instance = nil;

@implementation ADmuingDMManager

+ (instancetype)shareDMInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //默认
        self.type = 1;
    }
    return self;
}

#pragma mark --  Public Methods
- (void)start {
    if(!_comments || _comments.count <= 0){
        return;
    }
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(matchVC) userInfo:nil repeats:YES];
    }
}

- (void)stop {
    [_dm_container stop];
    [_dm_container removeFromSuperview];
    _dm_container = nil;
    _isShow = NO;

    [_timer invalidate];
    _timer = nil;
}

#pragma mark -- Load Comments
- (void)loadCommentsWithAdPackgeName:(NSString *)adPackgeName andAppKey:(NSString *)key{
    if (!key || key.length <= 0) {
        return;
    }
    if (!_dmCommentsRequest) {
        _dmCommentsRequest = [[ADmuingDMRequest alloc] initWithTarget:self onResult:@selector(receiveCommentsSuccess:) onError:nil];
    }
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    if (adPackgeName) {
        [body setObject:adPackgeName forKey:@"package_name"];
    }
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (!idfa) {
        idfa = @"00000000-0000-0000-000000000000";
    }
    long timestamp = [[NSDate date] timeIntervalSince1970];
    id lg = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString * lang = [[NSString alloc] initWithFormat:@"%@",lg];
    [body setObject:lang forKey:@"language"];
    [body setObject:bundleIdentifier forKey:@"app_package_name"];
    [body setObject:key forKey:@"app_key"];
    [body setObject:idfa forKey:@"idfa"];
    [body setObject:[NSNumber numberWithInteger:timestamp] forKey:@"timestamp"];

    NSURL *initUrl = [NSURL URLWithString:DM_COMMENTS_URL];
    [_dmCommentsRequest doRequest:@"POST" url:initUrl andBody:body];
}

- (void)receiveCommentsSuccess:(id)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 1) {
            NSArray *list = [result objectForKey:@"danmakus"];
            NSArray *cl = [result objectForKey:@"colors"];
            [self handleColors:cl];
            self.type = [[result objectForKey:@"type"] intValue];
            if (list.count > 0) {
                self.comments = list;
            }
        }
    }
}

- (void)handleColors:(NSArray *)cl{
    __block NSMutableArray *tArray= [NSMutableArray array];
    [cl enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *color = [self colorWithHexString:obj];
        [tArray addObject:color];
    }];
    
    self.colors = tArray;
}

#pragma mark --
- (void)addContainerInView:(UIView *)view{
    ADmuingDMContainerView *tv = [view viewWithTag:444];
    _dm_container = tv;
    
    if (view && !_dm_container) {
        _dm_container = [[ADmuingDMContainerView alloc] init];
        _dm_container.tag = 444;
        [view addSubview:_dm_container];
    }
    
    _dm_container.trajectoryNumber = self.trajectoryNumber;
    if (self.type == 1) {
        _dm_container.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    }else{
        _dm_container.frame = CGRectMake(0, 0.5 * CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), 0.5 * CGRectGetHeight(view.frame));
    }
}

- (void)setTrajectoryNumber:(NSInteger)trajectoryNumber{
    _trajectoryNumber = trajectoryNumber;
    _dm_container.trajectoryNumber = self.trajectoryNumber;
}

- (void)showComment{
    [_dm_container createDMViewWithComment:_comments andDirection:self.type];
}

- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 8)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark -- Match TopViewController
//匹配最上层控制器，匹配上则添加弹幕视图
- (void)matchVC{
    id vc = [self getCurrentVC];
    Class c = NSClassFromString(@"UADSViewController");
    Class c1 = NSClassFromString(@"VungleInternalMRAIDViewController");
    Class c2 = NSClassFromString(@"VungleAdViewController");
    Class c3 = NSClassFromString(@"AdTimingVideoController");
    if ([vc isKindOfClass:c]) {
        if ([vc respondsToSelector:@selector(currentViews)]) {
            NSArray *array = [vc currentViews];
            if ([array containsObject:@"videoplayer"] && !_isShow) {
                _isShow = YES;
                [self createDanmuView:((UIViewController *)vc).view];
                [self showComment];
            }else if(![array containsObject:@"videoplayer"]){
                _isShow = NO;
                [[ADmuingDMManager shareDMInstance] stop];
            }
        }
    }else if ([vc isKindOfClass:c1]) {
        NSArray *sView = ((UIViewController *)vc).view.subviews;
        id vungleDismissWebContainer = [sView firstObject];
        if (vungleDismissWebContainer && [vungleDismissWebContainer respondsToSelector:@selector(VungleDismissibleContainerView)]) {
            //id vungleDismissibleContainerView = [vungleDismissWebContainer VungleDismissibleContainerView];
        }
    }else if ([vc isKindOfClass:c2]) {
        if ([vc respondsToSelector:@selector(firstView)]) {
            BOOL firstView = [vc firstView];
            if (firstView && !_isShow) {
                _isShow = YES;
                [self createDanmuView:((UIViewController *)vc).view];
                [self showComment];
            }else if(!firstView){
                _isShow = NO;
                [[ADmuingDMManager shareDMInstance] stop];
            }
        }
    }else if ([vc isKindOfClass:c3]) {
        if ([vc respondsToSelector:@selector(floatingView)]){
            UIView *floatV = [vc floatingView];
            if (!_isShow) {
                _isShow = YES;
                [self createDanmuView:floatV];
                [self showComment];
            }
        }
    }else{
        _isShow = NO;
        [[ADmuingDMManager shareDMInstance] stop];
    }
}

- (void)createDanmuView:(UIView *)view{
    ADmuingDMManager *dmManager = [ADmuingDMManager shareDMInstance];
    [dmManager addContainerInView:view];
}

#pragma mark -- Get TopViewController
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

#pragma mark -- Other

- (void)delegate{
    
}

- (BOOL)firstView{
    return YES;
}

- (NSArray *)currentViews{
    return nil;
}

- (UIView *)floatingView{
    return nil;
}


- (void)isSuccessfulAdView{
    
}

-(id)VungleDismissibleContainerView{
    return nil;
}

@end
