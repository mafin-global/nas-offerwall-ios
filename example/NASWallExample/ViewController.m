//
//  ViewController.m
//  NASWallExample
//
//  Created by 박영철 on 2015. 9. 11..
//  Copyright © 2015년 NextApps, Inc. All rights reserved.
//

#import "ViewController.h"
#import "NASWall.h"
#import "Define.h"
#import "CustomTableViewController.h"
#import "EmbedViewController.h"

@interface ViewController () {
    CustomTableViewController *_customTableViewController;
}
@end

@implementation ViewController

- (void)loadView {
    [super loadView];

    [self setTitle:@"NASWall"];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    {
        // 내장 오퍼월(팝업)을 띄우는 버튼
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundColor:[UIColor yellowColor]];
        [button.titleLabel setTextColor:[UIColor blackColor]];
        [button setFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 40)];
        [button setTitle:@"내장 오퍼월 (팝업)" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(offerWallButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    {
        // 내장 오퍼월(임베드)을 띄우는 버튼
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundColor:[UIColor yellowColor]];
        [button.titleLabel setTextColor:[UIColor blackColor]];
        [button setFrame:CGRectMake(10, 150, self.view.bounds.size.width-20, 40)];
        [button setTitle:@"내장 오퍼월 (임베드)" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(offerWallEmbedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundColor:[UIColor yellowColor]];
        [button.titleLabel setTextColor:[UIColor blackColor]];
        [button setFrame:CGRectMake(10, 200, self.view.bounds.size.width-20, 40)];
        [button setTitle:@"사용자 정의 오퍼월" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customOfferWallButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    {
        // NAS 서버에서 포인트를 관리하는 경우 포인트를 조회하는 버튼
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundColor:[UIColor yellowColor]];
        [button.titleLabel setTextColor:[UIColor blackColor]];
        [button setFrame:CGRectMake(10, 250, self.view.bounds.size.width-20, 40)];
        [button setTitle:@"포인트 조회" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(getPointButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    {
        // NAS 서버에서 포인트를 관리하는 경우 포인트를 사용하는 버튼
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundColor:[UIColor yellowColor]];
        [button.titleLabel setTextColor:[UIColor blackColor]];
        [button setFrame:CGRectMake(10, 300, self.view.bounds.size.width-20, 40)];
        [button setTitle:@"포인트 사용" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(usePointButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _customTableViewController = nil;
}

#pragma mark -

- (void)NASWallClose {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"내장 오퍼월"
                                                    message:@"오퍼월이 종료되었습니다."
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)NASWallGetUserPointSuccess:(int)point unit:(NSString*)unit {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"포인트 조회"
                                                    message:[NSString stringWithFormat:@"포인트 조회가 완료되었습니다.\n남은 포인트 : %d %@", point, unit]
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)NASWallGetUserPointError:(int)errorCode {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"포인트 조회"
                                                    message:[NSString stringWithFormat:@"포인트 조회 중 오류가 발생했습니다.\n오류 코드 : %d", errorCode]
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)NASWallPurchaseItemSuccess:(NSString*)itemId count:(int)count point:(int)point unit:(NSString*)unit {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"포인트 사용"
                                                    message:[NSString stringWithFormat:@"아이템 구매가 완료되었습니다.\n남은 포인트 : %d %@", point, unit]
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)NASWallPurchaseItemNotEnoughPoint:(NSString*)itemId count:(int)count {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"포인트 사용"
                                                    message:@"포인트가 부족해서 아이템을 구매할 수 없습니다."
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)NASWallPurchaseItemError:(NSString*)itemId count:(int)count errorCode:(int)errorCode {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"포인트 사용"
                                                    message:[NSString stringWithFormat:@"아이템 구매 시 오류가 발생했습니다.\n오류 코드 : %d", errorCode]
                                                   delegate:nil
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)NASWallGetAdListSuccess:(NSArray*)adList {
    if (_customTableViewController) {
        [_customTableViewController NASWallGetAdListSuccess:adList];
    }
}

- (void)NASWallGetAdListError:(int)errorCode {
    if (_customTableViewController) {
        [_customTableViewController NASWallGetAdListError:errorCode];
    }
}

- (void)NASWallGetAdDescriptionSuccess:(NASWallAdInfo*)adInfo description:(NSString*)description {
    if (_customTableViewController) {
        [_customTableViewController NASWallGetAdDescriptionSuccess:adInfo description:description];
    }
}

- (void)NASWallGetAdDescriptionError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode {
    if (_customTableViewController) {
        [_customTableViewController NASWallGetAdDescriptionError:adInfo errorCode:errorCode];
    }
}

- (void)NASWallJoinAdSuccess:(NASWallAdInfo*)adInfo url:(NSString*)url {
    if (_customTableViewController) {
        [_customTableViewController NASWallJoinAdSuccess:adInfo url:url];
    }
}

- (void)NASWallJoinAdError:(NASWallAdInfo*)adInfo errorCode:(int)errorCode {
    if (_customTableViewController) {
        [_customTableViewController NASWallJoinAdError:adInfo errorCode:errorCode];
    }
}

- (void)NASWallOpenUrlSuccess:(NSString*)url {
    if (_customTableViewController) {
        [_customTableViewController NASWallOpenUrlSuccess:url];
    }
}

- (void)NASWallOpenUrlError:(NSString*)url errorCode:(int)errorCode {
    if (_customTableViewController) {
        [_customTableViewController NASWallOpenUrlError:url errorCode:errorCode];
    }
}

- (void)NASWallMustRefreshAdList {
    if (_customTableViewController) {
        [_customTableViewController NASWallMustRefreshAdList];
    }
}

#pragma mark - Button Click

- (void)offerWallButtonClick:(id)sender {
    [NASWall openWallWithUserData:USER_DATA];
}

- (void)offerWallEmbedButtonClick:(id)sender {
    EmbedViewController *viewController = [[EmbedViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)customOfferWallButtonClick:(id)sender {
    _customTableViewController = [[CustomTableViewController alloc] init];
    [self.navigationController pushViewController:_customTableViewController animated:YES];
}

- (void)getPointButtonClick:(id)sender {
    [NASWall getUserPoint];
}

- (void)usePointButtonClick:(id)sender {
    [NASWall purchaseItem:ITEM_ID];
}

@end
