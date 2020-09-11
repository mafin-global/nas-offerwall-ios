//
//  CustomTableViewCell.h
//  NASWall
//
//  Created by 박영철 on 2014. 8. 11..
//  Copyright (c) 2014년 NextApps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NASWall.h"

@interface CustomTableViewCell : UITableViewCell

- (void)updateWithAdInfo:(NASWallAdInfo*)info;

@end
