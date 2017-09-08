//
//  UnityVideoVC.m
//  DM_Demo
//
//  Created by 陈祖发 on 2017/9/5.
//  Copyright © 2017年 Copyright (c) 2017 1tu1shu. All rights reserved. All rights reserved.
//

#import "UnityVideoVC.h"
#import "ADmuingDMManager.h"

#define dm_app_key @"84865f00-90f4-4527-885b-cd9127565bd5"

@interface UnityVideoVC ()

@property(nonatomic , strong)IBOutlet UIButton *playButton;

@end



@implementation UnityVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[ADmuingDMManager shareDMInstance] setTrajectoryNumber:6];

    if ([UnityAds isReady:@"rewardedVideo"]) {
        [self updateButtonState:self.playButton enabled:YES];
        [[ADmuingDMManager shareDMInstance] loadCommentsWithAdPackgeName:@"" andAppKey:dm_app_key];
    }else{
        [self updateButtonState:self.playButton enabled:NO];
        [UnityAds initialize:@"1074048" delegate:self testMode:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateButtonState:(UIButton *) button enabled:(BOOL)enabled {
    button.enabled = enabled;
    button.alpha = (enabled? 1.0:0.45);
}

- (IBAction)playBtn:(id)sender {
    if ([UnityAds isReady:@"rewardedVideo"]) {
        [self updateButtonState:self.playButton enabled:NO];
        [UnityAds show:self placementId:@"rewardedVideo"];
    }
}

#pragma mark -- UnityAdsDelegate
- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"isReady");
    [self updateButtonState:self.playButton enabled:YES];
    [[ADmuingDMManager shareDMInstance] loadCommentsWithAdPackgeName:@"" andAppKey:dm_app_key];

}
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    
}

- (void)unityAdsDidStart:(NSString *)placementId{
    [[ADmuingDMManager shareDMInstance] start];
}

- (void)unityAdsDidFinish:(NSString *)placementId
          withFinishState:(UnityAdsFinishState)state{
    [[ADmuingDMManager shareDMInstance] stop];
}
@end
