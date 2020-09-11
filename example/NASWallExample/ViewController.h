//
//  ViewController.h
//  NASWallExample
//
//  Created by 박영철 on 2015. 9. 11..
//  Copyright © 2015년 NextApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NASWall.h"

@interface ViewController : UIViewController

- (void)NASWallClose;
- (void)NASWallGetUserPointSuccess:(int)point unit:(NSString*)unit;
- (void)NASWallGetUserPointError:(int)errorCode;
- (void)NASWallPurchaseItemSuccess:(NSString*)itemId count:(int)count point:(int)point unit:(NSString*)unit;
- (void)NASWallPurchaseItemNotEnoughPoint:(NSString*)itemId count:(int)count;
- (void)NASWallPurchaseItemError:(NSString*)itemId count:(int)count errorCode:(int)errorCode;
- (void)NASWallGetAdListSuccess:(NSArray*)adList;
- (void)NASWallGetAdListError:(int)errorCode;
- (void)NASWallGetAdDescriptionSuccess:(NASWallAdInfo*)adInfo description:(NSString*)description;
- (void)NASWallGetAdDescriptionError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode;
- (void)NASWallJoinAdSuccess:(NASWallAdInfo*)adInfo url:(NSString*)url;
- (void)NASWallJoinAdError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode;
- (void)NASWallOpenUrlSuccess:(NSString*)url;
- (void)NASWallOpenUrlError:(NSString*)url errorCode:(int)errorCode;
- (void)NASWallMustRefreshAdList;


@end

