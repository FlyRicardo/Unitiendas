
//
//  ViewControllerPromotionList.m
//  Unitienda
//
//  Created by Fly on 5/7/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerPromotionList.h"
#import "WebServiceAbstractFactory.h"

#import "RefreshTokenMetaMO.h"

#import "Constants.h"
#import "ArticleMO.h"
#import "MetaMO.h"

#import "TableViewCellPromotion.h"


@interface ViewControllerPromotionList()

@property (nonatomic) RefreshTokenMetaMO* refreshTokenResponseMO;

@end

@implementation ViewControllerPromotionList

-(void) viewDidLoad{
    [self requestGetPromotionsByStore];
    [self configureNavigationBar];
}

-(void) viewWillAppear:(BOOL)animated{
    [self registerNotifyProcess];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self unregisterNotifyProcess];
}

#pragma mark - NavigationController configuration
-(void) configureNavigationBar{
    //Shows the navigatoin bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //The index of View controllers, for this case, should be : 2 , or the second view Added to the Navigation Controler
    UINavigationController *navigationController = [self.navigationController.viewControllers lastObject];
    UINavigationBar *navigationBar =[[navigationController navigationController] navigationBar];
    UINavigationItem* navigationItem = [navigationController navigationItem];
    
    [navigationBar setBarTintColor:[UIColor colorWithRed:(240.0/255.0) green:(141.0/255.0) blue:(36.0/255.0) alpha:1]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navigationItem setTitle: @"Promociones"];
    [navigationItem setHidesBackButton:YES];
}

#pragma mark - Call Web services

-(void) requestGetPromotionsByStore{
    id wsPromotionConnector = [WebServiceAbstractFactory createWebServicePromotionConnection:ApacheType];
    NSLog(@"Store id: %li",(long)[[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_STORE_ID]] integerValue]);
    [wsPromotionConnector getPromotionsByStore:[[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_STORE_ID]] integerValue]];
}

-(void) requestRefreshToken{
    
    id _wsLoginConnection = [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    [_wsLoginConnection refreshTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_GRANT_TYPE_REFRESH_TOKEN]]];
    
}


#pragma mark - Notifying Web Service proccess

-(void)registerNotifyProcess{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePromotionsByStoreNotification:)
                                                 name:[Constants GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRefreshNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_RESPONSE_NOTIFICATION]
                                               object:nil];

}

-(void) unregisterNotifyProcess{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION]
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                name:[Constants GET_LABEL_NAME_PROMOTION_BY_STORE_RESPONSE_NOTIFICATION]
                                               object:nil];
}

-(void)receivePromotionsByStoreNotification:(NSNotification *) notification{
    
    NSDictionary *dictionary = notification.userInfo;
    if([dictionary[[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION]] isKindOfClass:[NSArray class]]){
        NSLog(@"receivePromotionsByStoreNotification Method, as successful response");
    }else if([dictionary[[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION]] isKindOfClass:[MetaMO class]]){
        NSLog(@"receivePromotionsByStoreNotification Method, as unsuccesful response");
    }
}

-(void)receiveRefreshNotification:(NSNotification *) notification{
    NSDictionary *dictionary = notification.userInfo;
    _refreshTokenResponseMO = (RefreshTokenMetaMO*) dictionary[[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]];
    
    if([[_refreshTokenResponseMO errorDetail ] containsString: [Constants GET_ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE] ]){     //Refresh token has expired. The authentication proccess has to star again.
        
        //Return application to loggin (remove as many view as viewController had sotored)
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
        [viewControllers removeLastObject];
        [[self navigationController] setViewControllers:viewControllers animated:YES];
        
        
    }else if([_refreshTokenResponseMO errorDetail] == 0){         //Not error reported
        
        //Save the access and refresh token, and username
        [[NSUserDefaults standardUserDefaults]setObject:[_refreshTokenResponseMO accessToken] forKey:@"access_token"];
        
        [self requestGetPromotionsByStore];
    }
}


#pragma mark - Implemented UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identifier = @"promotionCell";
    TableViewCellPromotion* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell==nil){
        cell = [[TableViewCellPromotion alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kNormalCellHeigh = 94;
    return  kNormalCellHeigh;
}


@end
