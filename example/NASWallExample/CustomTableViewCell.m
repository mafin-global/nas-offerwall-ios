//
//  CustomTableViewCell.m
//  NASWall
//
//  Created by 박영철 on 2014. 8. 11..
//  Copyright (c) 2014년 NextApps, Inc. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell () <NSURLConnectionDelegate> {
    NSURLConnection     *_conn;
    NSMutableData       *_data;
    
    UIImageView         *_iconImageView;
    UILabel             *_titleLabel;
    UILabel             *_missionLabel;
    UILabel             *_rewardLabel;
    UILabel             *_installCheckLabel;
    
    NASWallAdInfo       *_adInfo;
}
@end

@implementation CustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _data = [[NSMutableData alloc] init];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, self.bounds.size.width-110, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_titleLabel];
        
        _missionLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, self.bounds.size.width-55, 15)];
        [_missionLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_missionLabel];
        
        _rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 35, self.bounds.size.width-55, 15)];
        [_rewardLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_rewardLabel];
        
        _installCheckLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-55, 15, 50, 20)];
        [_installCheckLabel setFont:[UIFont systemFontOfSize:13]];
        [_installCheckLabel setTextColor:[UIColor blueColor]];
        [_installCheckLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_installCheckLabel];
    }
    return self;
}

- (void)dealloc {
    if (_data) {
        _data = nil;
    }
    if (_adInfo) {
        _adInfo = nil;
    }
}

- (void)updateWithAdInfo:(NASWallAdInfo*)info {
    _adInfo = info;
    
    [_iconImageView setImage:nil];
    [_titleLabel setText:info.title];
    [_missionLabel setText:info.missionText];
    [_rewardLabel setText:[NSString stringWithFormat:@"%d%@", info.rewardPrice, info.rewardUnit]];

    if (info.adType == NAS_WALL_AD_TYPE_CPI && info.joinStatus == NAS_WALL_JOIN_STATUS_JOIN) {
        [_installCheckLabel setText:@"설치확인"];
    } else {
        [_installCheckLabel setText:@""];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/naswall/", NSTemporaryDirectory()];
    NSString *filePath = [NSString stringWithFormat:@"%@%@", path, _adInfo.adKey];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [_iconImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]]];
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:info.iconUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        _conn = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if (_data) [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_data) [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_data) {
        UIImage *img = [UIImage imageWithData:_data];
        if (img) {
            NSString *path = [NSString stringWithFormat:@"%@/naswall/", NSTemporaryDirectory()];
            NSString *filePath = [NSString stringWithFormat:@"%@%@", path, _adInfo.adKey];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                if ([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
                    [_data writeToFile:filePath atomically:YES];
                }
            } else {
                [_data writeToFile:filePath atomically:YES];
            }
            
            [_iconImageView setImage:img];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}

@end
