

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommentMoveStatus) {
    CommentMoveStart,
    CommentMoveEnter,
    CommentMoveEnd
};

@interface ADmuingDMView : UIView

@property (nonatomic, copy) void(^moveStatusBlock)(CommentMoveStatus status);
@property (nonatomic, strong) UILabel *lbComment;
@property (nonatomic, assign) NSInteger trajectory; //弹道

- (instancetype)initWithContent:(NSString *)content direction:(int)dir;

- (void)startAnimation:(int)direction;

- (void)stopAnimation;

@end
