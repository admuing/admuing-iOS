

#import "ADmuingDMView.h"
#import "ADmuingDMManager.h"

#define mDuration   8
#define Padding  5
#define lWidth 30

@interface ADmuingDMView ()

@property BOOL bDealloc;

@end


@implementation ADmuingDMView

- (void)dealloc {
    [self stopAnimation];
    self.moveStatusBlock = nil;
}

- (instancetype)initWithContent:(NSString *)content direction:(int)dir{
    if (self == [super init]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        float width = [content sizeWithAttributes:attributes].width;
        self.bounds = CGRectMake(0, 0, width + Padding*2, lWidth);
        
        self.lbComment = [UILabel new];
        self.lbComment.frame = CGRectMake(Padding, 0, (width), lWidth);
        self.lbComment.backgroundColor = [UIColor clearColor];
        self.lbComment.text = content;
        self.lbComment.font = [UIFont systemFontOfSize:16];
        NSArray *cl = [[ADmuingDMManager shareDMInstance] colors];
        self.lbComment.textColor =  [self randomColor:cl];
        [self addSubview:self.lbComment];
    }
    return self;
}

//颜色随机
- (UIColor *)randomColor:(NSArray *)colors{
    if (colors.count <= 0) {
        return [UIColor whiteColor];
    }
    UIColor *color;
    NSInteger randomNumber = arc4random() % colors.count;
    color = [colors objectAtIndex:randomNumber];
    return color;
}

- (void)startAnimation:(int)direction{
    //根据定义的duration计算速度以及完全进入屏幕的时间
    CGFloat dur;
    if (direction == 2) { //由底部往上
        CGRect fRect = self.superview.bounds;
        CGFloat wholeHeight = CGRectGetHeight(self.frame) + CGRectGetHeight(fRect);
        CGFloat speed = wholeHeight/mDuration;
        dur = (CGRectGetHeight(self.frame) - 10)/speed;
    }else{
        CGRect fRect = self.superview.bounds;
        CGFloat wholeWidth = CGRectGetWidth(self.frame) + CGRectGetWidth(fRect);
        CGFloat speed = wholeWidth/mDuration;
        dur = (CGRectGetWidth(self.frame) + 30)/speed;
    }
    
    __block CGRect frame = self.frame;
    if (self.moveStatusBlock) {
        //弹幕开始进入屏幕
        self.moveStatusBlock(CommentMoveStart);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dur * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.bDealloc) {
            return;
        }
        if (self.moveStatusBlock) {
            self.moveStatusBlock(CommentMoveEnter);
        }
    });
    
    [UIView animateWithDuration:mDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (direction == 2) {
            frame.origin.y = -CGRectGetHeight(frame);
        }else{
            frame.origin.x = -CGRectGetWidth(frame);
        }
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.moveStatusBlock) {
            self.moveStatusBlock(CommentMoveEnd);
        }
        [self removeFromSuperview];
    }];
}

- (void)stopAnimation {
    self.bDealloc = YES;
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
