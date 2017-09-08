

#import "ADmuingDMContainerView.h"
#import "ADmuingDMView.h"


@interface ADmuingDMContainerView()

@property (nonatomic, assign) NSInteger hasshow_comment;
@property (nonatomic, assign) NSInteger dmNumber;         //弹幕条数
@property (nonatomic, strong) NSMutableArray *allComments;
@property (nonatomic, strong) NSMutableArray *dmQueue;

@property (nonatomic, assign)BOOL isShow;
@property (nonatomic, assign)BOOL isClose;
@property (nonatomic, assign)int dmDirction;

@end

@implementation ADmuingDMContainerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark - Private
/**
 *  初始化弹幕
 */
- (void)createDMViewWithComment:(NSArray *)comments andDirection:(DMDirection)direction{
    if (_isShow) {
        return;
    }
    _dmDirction = direction;
    _hasshow_comment = 0;
    _dmNumber = comments.count;
    self.allComments = [[NSMutableArray alloc] initWithArray:comments];
    if (_dmDirction == 2) {
        NSString *comment = [self nextComment];
        if (comment) {
            [self createBulletComment:comment trajectory:0];
        }
    }else{
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.trajectoryNumber; i++) {
            [arr addObject:[NSNumber numberWithInteger:i]];
        }
        NSInteger delayTime = 0;
        for (NSInteger i = self.trajectoryNumber; i > 0; i--) {
            NSString *comment = [self nextComment];
            if (comment) {
                //随机生成弹道创建弹幕进行展示（弹幕的随机飞入效果）
                NSInteger index = arc4random()%arr.count;
                NSInteger trajectory = [[arr objectAtIndex:index] intValue];
                [arr removeObjectAtIndex:index];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:comment forKey:@"comment"];
                [dic setObject:[NSNumber numberWithInteger:trajectory] forKey:@"trajectory"];
                [self performSelector:@selector(delayCreate:) withObject:dic afterDelay:delayTime];
                delayTime++;
            }
        }
    }
    
    _isShow = YES;
    _isClose = NO;
}

/**
 *  创建弹幕
 *
 *  @param comment    弹幕内容
 *  @param trajectory 弹道位置
 */

- (void)createBulletComment:(NSString *)comment trajectory:(NSInteger)trajectory {
    //创建一个弹幕view
    ADmuingDMView *view = [[ADmuingDMView alloc] initWithContent:comment direction:_dmDirction];
    view.trajectory = trajectory;
    __weak ADmuingDMView *weakBulletView = view;
    __weak ADmuingDMContainerView *myself = self;
 
    view.moveStatusBlock = ^(CommentMoveStatus status) {
        switch (status) {
            case CommentMoveStart:
                //弹幕开始……将view加入弹幕管理queue
                [self.dmQueue addObject:weakBulletView];
                break;
            case CommentMoveEnter: {
                //弹幕完全进入屏幕，判断接下来是否还有内容，如果有则在该弹道轨迹对列中创建弹幕……
                NSString *comment = [myself nextComment];
                if (comment) {
                    [myself createBulletComment:comment trajectory:trajectory];
                } else {
                    //说明到了评论的结尾了
                }
                break;
            }
            case CommentMoveEnd: {
                _hasshow_comment++;
                //弹幕飞出屏幕后从弹幕管理queue中删除
                if ([myself.dmQueue containsObject:weakBulletView]) {
                    [myself.dmQueue removeObject:weakBulletView];
                }
                if (_hasshow_comment == _dmNumber) {
                    [self stop];
                }
                break;
            }
            default:
                break;
        }
    };
    //弹幕生成后，开始出现的地方
    if (_dmDirction == 1) {
        view.frame = CGRectMake(CGRectGetWidth(self.frame), 10 + 34 * view.trajectory, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        [self addSubview:view];
        //[view startAnimationDefault];
    }else{
        view.frame = CGRectMake(0, CGRectGetHeight(self.frame) + CGRectGetHeight(view.bounds) , CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        [self addSubview:view];
        //[view startAnimationBTT];
    }
    [view startAnimation:_dmDirction];
}


- (void)delayCreate:(NSDictionary *)objc{
    NSString *comment = [objc objectForKey:@"comment"];
    NSInteger trajectory = [[objc objectForKey:@"trajectory"] intValue];
    [self createBulletComment:comment trajectory:trajectory];
}

- (NSString *)nextComment {
    NSString *comment = [self.allComments firstObject];
    if (comment) {
        [self.allComments removeObjectAtIndex:0];
    }
    return comment;
}

- (void)stop{
    _isShow = NO;
    _isClose = YES;
    _hasshow_comment = 0;
    _dmNumber = 0;

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ADmuingDMView class]]) {
            [(ADmuingDMView *)obj stopAnimation];
        }
    }];
}

@end
