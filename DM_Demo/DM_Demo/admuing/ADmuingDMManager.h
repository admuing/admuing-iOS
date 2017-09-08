

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ADmuingDMManager : NSObject

@property (nonatomic, assign) NSInteger trajectoryNumber; //弹道数目
@property (nonatomic, strong ,readonly) NSMutableArray *colors;

+ (instancetype)shareDMInstance;

- (void)loadCommentsWithAdPackgeName:(NSString *)adPackgeName andAppKey:(NSString *)key;

- (void)start;

- (void)stop;

@end
