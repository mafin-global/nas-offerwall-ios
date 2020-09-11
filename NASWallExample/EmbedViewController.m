//
//  EmbedViewController.m
//  NASWall
//
//  Created by 박영철 on 2016. 4. 12..
//  Copyright © 2016년 NextApps, Inc. All rights reserved.
//

#import "EmbedViewController.h"
#import "NASWall.h"
#import "Define.h"

@interface EmbedViewController ()

@end

@implementation EmbedViewController

- (void)loadView
{
    [super loadView];
    
    [self setTitle:@"내장 오퍼월 (임베드)"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    float x = 10;
    float y = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.bounds.size.height + 10;
    float w = self.view.bounds.size.width-20;
    float h = self.view.bounds.size.height - y - 10;
    
    UIView *embedView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [embedView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:embedView];

    [NASWall embedWallWithParent:embedView userData:USER_DATA];
}

@end
