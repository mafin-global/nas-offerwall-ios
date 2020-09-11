//
//  AppDelegate.m
//  NASWallExample
//
//  Created by 박영철 on 2015. 9. 11..
//  Copyright © 2015년 NextApps, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NASWall.h"
#import "Define.h"

@interface AppDelegate () <NASWallDelegate> {
    ViewController *_viewController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 초기화 - 개발자 서버에서 포인트를 관리하는 경우
    [NASWall initWithAppKey:APP_KEY testMode:TEST_MODE delegate:self];

    // 초기화 - NAS 서버에서 포인트를 관리하는 경우
    //[NASWall initWithAppKey:APP_KEY testMode:TEST_MODE userId:USER_ID delegate:self];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    _viewController = [[ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:_viewController];
    [self.window setRootViewController:navi];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [NASWall applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [NASWall applicationWillEnterForeground];
}

#pragma mark - NASWallDelegate

- (void)NASWallClose {
    [_viewController NASWallClose];
}

- (void)NASWallGetUserPointSuccess:(int)point unit:(NSString*)unit {
    [_viewController NASWallGetUserPointSuccess:point unit:unit];
}

- (void)NASWallGetUserPointError:(int)errorCode {
    [_viewController NASWallGetUserPointError:errorCode];
}

- (void)NASWallPurchaseItemSuccess:(NSString*)itemId count:(int)count point:(int)point unit:(NSString*)unit {
    [_viewController NASWallPurchaseItemSuccess:itemId count:count point:point unit:unit];
}

- (void)NASWallPurchaseItemNotEnoughPoint:(NSString*)itemId count:(int)count {
    [_viewController NASWallPurchaseItemNotEnoughPoint:itemId count:count];
}

- (void)NASWallPurchaseItemError:(NSString*)itemId count:(int)count errorCode:(int)errorCode {
    [_viewController NASWallPurchaseItemError:itemId count:count errorCode:errorCode];
}

- (void)NASWallGetAdListSuccess:(NSArray*)adList {
    [_viewController NASWallGetAdListSuccess:adList];
}

- (void)NASWallGetAdListError:(int)errorCode {
    [_viewController NASWallGetAdListError:errorCode];
}

- (void)NASWallGetAdDescriptionSuccess:(NASWallAdInfo*)adInfo description:(NSString*)description {
    [_viewController NASWallGetAdDescriptionSuccess:adInfo description:description];
}

- (void)NASWallGetAdDescriptionError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode {
    [_viewController NASWallGetAdDescriptionError:adInfo errorCode:errorCode];
}

- (void)NASWallJoinAdSuccess:(NASWallAdInfo*)adInfo url:(NSString*)url {
    [_viewController NASWallJoinAdSuccess:adInfo url:url];
}

- (void)NASWallJoinAdError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode {
    [_viewController NASWallJoinAdError:adInfo errorCode:errorCode];
}

- (void)NASWallOpenUrlSuccess:(NSString*)url {
    [_viewController NASWallOpenUrlSuccess:url];
}

- (void)NASWallOpenUrlError:(NSString*)url errorCode:(int)errorCode {
    [_viewController NASWallOpenUrlError:url errorCode:errorCode];
}

- (void)NASWallMustRefreshAdList {
    [_viewController NASWallMustRefreshAdList];
}

@end
