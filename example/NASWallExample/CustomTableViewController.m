//
//  CustomTableViewController.m
//  NASWall
//
//  Created by 박영철 on 2014. 8. 11..
//  Copyright (c) 2014년 NextApps, Inc. All rights reserved.
//

#import "CustomTableViewController.h"
#import "Define.h"
#import "NASWall.h"
#import "CustomTableViewCell.h"

@interface CustomTableViewController () {
    NSArray         *_adList;
    UIAlertView     *_alertView;
    BOOL            _isLoading;
}

@property (nonatomic, retain)   NSArray     *adList;

- (void)loadAdList;
- (void)joinAd:(NASWallAdInfo*)adInfo;
- (void)loadComplete;
@end

@implementation CustomTableViewController

@synthesize adList = _adList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self setTitle:@"사용자 정의 UI"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self loadAdList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_adList)
        return [_adList count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NASWallAdInfo *adInfo = [_adList objectAtIndex:indexPath.row];
    [cell updateWithAdInfo:adInfo];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NASWallAdInfo *adInfo = [_adList objectAtIndex:indexPath.row];
    [self joinAd:adInfo];
}

#pragma mark -

- (void)loadAdList
{
    if (_isLoading) return;
    _isLoading = YES;
    
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Loading..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [_alertView show];
    
    [NASWall getAdList:USER_DATA];
}

- (void)joinAd:(NASWallAdInfo*)adInfo
{
    if (_isLoading) return;
    _isLoading = YES;
    
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Loading..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [_alertView show];
    
    [NASWall joinAd:adInfo];
}

- (void)loadComplete
{
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView = nil;
    }
    _isLoading = NO;
}

#pragma mark -

- (void)NASWallGetAdListSuccess:(NSArray*)adList
{
    self.adList = adList;
    [self.tableView reloadData];
    
    [self loadComplete];
}

- (void)NASWallGetAdListError:(int)errorCode
{
    self.adList = nil;
    [self.tableView reloadData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정의 오퍼월"
                                                     message:[NSString stringWithFormat:@"(%d) 오류가 발생했습니다.", errorCode]
                                                    delegate:nil
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
    [alert show];

    [self loadComplete];
}

- (void)NASWallGetAdDescriptionSuccess:(NASWallAdInfo*)adInfo description:(NSString*)description {
    NSLog(@"%@", description);
}

- (void)NASWallGetAdDescriptionError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode {
    NSString *message = nil;
    switch (errorCode) {
        case -1:
            message = [NSString stringWithFormat:@"(%d) 사용할 수 없는 캠페인입니다.", errorCode];
            break;
        default:
            message = [NSString stringWithFormat:@"(%d) 광고 상세 설명글을 가져올 수 없습니다.", errorCode];
            break;
    }
    NSLog(@"%@", message);
}

- (void)NASWallJoinAdSuccess:(NASWallAdInfo*)adInfo url:(NSString*)url
{
    [NASWall openUrl:url];
    
    [self loadComplete];
}

- (void)NASWallJoinAdError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode
{
    NSString *message = nil;
    switch (errorCode) {
        case -10001:
            message = [NSString stringWithFormat:@"(%d) 종료된 캠페인입니다.", errorCode];
            break;
        case -20001:
            message = [NSString stringWithFormat:@"(%d) 이미 참여한 캠페인입니다.", errorCode];
            break;
        default:
            message = [NSString stringWithFormat:@"(%d) 캠페인에 참여할 수 없습니다.", errorCode];
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정의 오퍼월"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self loadComplete];
}

- (void)NASWallOpenUrlSuccess:(NSString*)url {
    
}

- (void)NASWallOpenUrlError:(NSString*)url errorCode:(int)errorCode {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"사용자 정의 오퍼월"
                                                     message:@"캠페인에 참여할 수 없습니다."
                                                    delegate:nil
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void)NASWallMustRefreshAdList {
    [self loadAdList];
}

@end
