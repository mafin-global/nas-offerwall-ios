//
//  CustomTableViewController.h
//  NASWall
//
//  Created by 박영철 on 2014. 8. 11..
//  Copyright (c) 2014년 NextApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NASWall.h"

@interface CustomTableViewController : UITableViewController

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
