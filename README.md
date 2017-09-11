# AdMuing

This is iOS version， Android is [here](https://github.com/admuing/admuing-android)

[中文版说明](admuing-iOS/README_CN.md)

## About

AdMuing is a video advertising Danmaku enhancement tool,Is an open source project created by years of research google & facebbok creative team，The purpose is to change the existing video advertising style is single，the problem of globalization is difficult to solve，With AdMuing, just a few lines of code can make the original video ads more vivid, interesting and interactive，Enhance the quality of developers APP ad, so that video ads more attractive to users.

## Demo

Source code：Please see the admuing file.
Demo：This demo contains examples of use in the unity and vungle SDK.

## Features
Free：Completely free during use API，(Each key calls 10000 times per day because of server pressure)
Open Source：Each line of code on the GitHub is visible, fully transparent, and there is no need to worry about malicious code calls
Small: IOS and Android SDK are less than 50K
Simple: 4,5 lines of code, from the beginning to the finish, <5 minutes
Globalization: support 16 languages, 200+ countries, according to different regions display different languages, different Danmaku styles and colors
3rd Platform support: compatible support, Unity, Vungle and other mainstream Video video advertising，Does not affect or change any functionality or logic of the original Video SDK


## How to work

AdMuing SDK Danmaku SDK call API Danmaku display, according to user requests, IP, appkey, advertising, ID, mobile phone language, such as intelligent matching Danmaku

* according to the  video ads APP matching appropriate Danmaku, Danmaku from application market comments and web content crawl
* According to the semantic recognition system, remove meaningless, negative comments on the Danmaku
* According to the user's mobile phone language match Danmaku language ，currently supports 16 languages: simplified Chinese, traditional Chinese, English, Portuguese, French, Spanish, Russian, Arabic, German, Japanese, Korean, Hindi, Indonesian, Malay, Thai, Vietnamese, italian.
* Show different Danmaku styles according to the user's country, such as the display of Danmaku effect in China, and the display effect of rolling commentary in the US area.
* Danmaku color：Show different color of the Danmaku according to the color and taboo color of the users in different countries，example：red, yellow and blue in china，green and white in Saudi Arabia，Orange, white,and green in India


## HOW To Get Started

#### Apply For A Key

Go to the [registered address](http://register.admuing.com/) to apply for an appkey.


#### Usage

* Download this item and add admuing file to your project.
* import "AdTimingDMManager.h".
* Set the number of trajectories.

 ```
    [[ADmuingDMManager shareDMInstance] setTrajectoryNumber:6];
 ```
 
* Loading barrage content.
 
 ```
    [[ADmuingDMManager shareDMInstance] loadCommentsWithAdPackgeName:@"" andAppKey:dm_app_key];
 ```

* Displays the barrage as the video starts playing.

 ```
   [[ADmuingDMManager shareDMInstance] start];
 ```
 
* Remove the barrage at the end of the video play.

 ```
   [[ADmuingDMManager shareDMInstance] stop];
 ```
 
##### In order to support http requests,Please do the following configuration in the info.plist file.

   ![img](IMG/ats.png)

## Remarks

* Current compatible ad platform：Unity、Vungle、AdTiming.Constantly update....
Theory can support all video Ad SDK，But need to test， If need to support more platforms, please contact us.Our email is <font color=red>support@admuing.com</font>
* Currently only supports iOS7.0 or later
 
## Support
* create an issue on the github issue page.
* support email: <font color=red>support@admuing.com</font>. 

 We will reply as soon as possible.
