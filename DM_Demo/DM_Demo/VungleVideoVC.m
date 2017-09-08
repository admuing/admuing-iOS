//
//  VungleVideoVC.m
//  DM_Demo
//
//  Created by 陈祖发 on 2017/9/5.
//  Copyright © 2017年 Copyright (c) 2017 1tu1shu. All rights reserved. All rights reserved.
//

#import "VungleVideoVC.h"
#import <VungleSDK/VungleSDK.h>
#import "ADmuingDMManager.h"

static NSString *const kVungleTestAppID = @"58fe200484fbd5b9670000e3";
static NSString *const kVungleTestPlacementID01 = @"DEFAULT87043"; // auto cache placement

#define dm_app_key @"84865f00-90f4-4527-885b-cd9127565bd5"

@interface VungleVideoVC ()<VungleSDKDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIButton *playButton1;
@property(nonatomic , strong)IBOutlet UIButton* sdkInitButton;

@property (nonatomic, strong) VungleSDK *sdk;
@end

@implementation VungleVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateButtonState:self.playButton1 enabled:NO];

    [[ADmuingDMManager shareDMInstance] setTrajectoryNumber:8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startVungle:(id)sender{
    [self updateButtonState:self.sdkInitButton enabled:NO];
    
    self.sdk = [VungleSDK sharedSDK];
    [self.sdk setDelegate:self];
    NSError *error = nil;
    
    if(![self.sdk startWithAppId:kVungleTestAppID placements:@[kVungleTestPlacementID01] error:&error]) {
        NSLog(@"Error while starting VungleSDK %@", [error localizedDescription]);
        
        [self updateButtonState:self.sdkInitButton enabled:YES];
        return;
    }
}

- (void)updateButtonState:(UIButton *) button enabled:(BOOL)enabled {
    button.enabled = enabled;
    button.alpha = (enabled? 1.0:0.45);
}

- (IBAction)showAdForPlacement01 {
    // Play a Vungle ad (with default options)
    NSError *error;
    [self.sdk playAd:self options:nil placementID:kVungleTestPlacementID01 error:&error];
    
    if (error) {
        NSLog(@"Error encountered playing ad: %@", error);
    }
}

#pragma mark - VungleSDKDelegate Methods

- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(NSString *)placementID {
    if (isAdPlayable) {
        NSLog(@"-->> Delegate Callback: vungleAdPlayabilityUpdate: Ad is available for Placement ID: %@", placementID);
    }
    else {
        NSLog(@"-->> Delegate Callback: vungleAdPlayabilityUpdate: Ad is NOT availablefor Placement ID: %@", placementID);
    }
    
    if ([placementID isEqualToString:kVungleTestPlacementID01]) {
        [self updateButtonState:self.playButton1 enabled:isAdPlayable];
    }
    [[ADmuingDMManager shareDMInstance] loadCommentsWithAdPackgeName:@"" andAppKey:dm_app_key];

}

- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID {
    NSLog(@"-->> Delegate Callback: vungleSDKwillShowAd");
    [[ADmuingDMManager shareDMInstance] start];
    
    if ([placementID isEqualToString:kVungleTestPlacementID01]) {
        NSLog(@"-->> Ad will show for Placment 01");
        [self updateButtonState:self.playButton1 enabled:NO];
    }
    
}

- (void)vungleWillCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID {
    NSLog(@"-->> Delegate Callback: vungleWillCloseAdWithViewInfo");
    [[ADmuingDMManager shareDMInstance] stop];

    if ([placementID isEqualToString:kVungleTestPlacementID01]) {
        NSLog(@"-->> Ad is closed for Placment 01");
    }
    
    
    if (info) {
        NSLog(@"Info about ad viewed: %@", info);
    }
    
    [self updateButtonState:self.playButton1 enabled:[self.sdk isAdCachedForPlacementID:kVungleTestPlacementID01]? YES:NO];
}

- (void)vungleSDKDidInitialize {
    NSLog(@"-->> Delegate Callback: vungleSDKDidInitialize - SDK initialized SUCCESSFULLY");
}

@end
