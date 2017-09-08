

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DMDirectionRTL = 1,
    DMDirectionBTT         //只有一个弹道
} DMDirection;

@interface ADmuingDMContainerView : UIView

@property (nonatomic, assign) NSInteger trajectoryNumber; //弹道数目
@property (nonatomic, strong) NSArray *colors;
- (instancetype)init;

- (void)createDMViewWithComment:(NSArray *)comments andDirection:(DMDirection)direction;

- (void)stop;

@end
