//
//  ViewControllerHome.m
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerHome.h"
#import "WebServiceAbstractFactory.h"

#import "RefreshTokenMetaMO.h"
#import "LogoutMetaMO.h"

#import "ViewControllerLogin.h"

#import "Constants.h"


@interface ViewControllerHome()

@property (nonatomic) RefreshTokenMetaMO* refreshTokenResponse;
@property (nonatomic) LogoutMetaMO*  logoutResponseMO;

@property (nonatomic) UIAlertController *alertController;

@end

@implementation ViewControllerHome

-(void) viewWillAppear:(BOOL)animated{
    
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    //Hide the back-button on login frame
    [self configureNavigationBar];
    [self registerNotifyProcess];
    
    //Associate touch acctions to buttons of IB
    [_usingTokenButton addTarget:self action:@selector(methodTouchUpInside:) forControlEvents:UIControlEventTouchDown];
    
    [_accessTokenLabel setText:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    [self refreshView];

}

-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidDisappear, on ViewControllerHome.");
}

-(void) viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear, on ViewControllerHome.");
}

-(void) viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear, on ViewControllerHome.");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshView{
    NSString* firstName =[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_FIRST_NAME]];
    NSString* lastName = [[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_LAST_NAME]];
    [_labelUserName setText:[NSString stringWithFormat:@"%@ %@",firstName, lastName]];
    [_accessTokenLabel setText:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
}

#pragma mark - NavigationController configuration

-(void) configureNavigationBar{
    
    //Shows the navigatoin bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //The index of View controllers, for this case, should be : 1 , or the second view Added to the Navigation Controler
    UINavigationController *navigationController = [self.navigationController.viewControllers objectAtIndex:1];
    UINavigationBar *navigationBar =[[navigationController navigationController] navigationBar];
    UINavigationItem* navigationItem = [navigationController navigationItem];
    
    [navigationBar setBackgroundColor:[UIColor yellowColor]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navigationItem setTitle: @"Crear perfilr"];
    [navigationItem setHidesBackButton:YES];
    [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(methodTouchLogoutButtonUpIndide)]];
}

#pragma mark - WS routines

-(void) refreshWithAbstractFactory
{
    //Register the notification proccess of complete the fetching data
    [self registerNotifyProcess];
    
    id wsLoginConnection =  [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    [wsLoginConnection refreshTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_NAME_REFRESH_TOKEN]]];
}

-(void) logoutWithAbstractFactory{
    [self registerNotifyProcess];
    
    id wsLoginConnection =  [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    [wsLoginConnection executeLogout];
}

#pragma mark - Notifying proccess

-(void)registerNotifyProcess{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationViewControllerHome:)
                                                 name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationViewControllerHome:)
                                                 name:[Constants GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION]
                                               object:nil];
    
}


- (void) receiveNotificationViewControllerHome:(NSNotification *) notification
{
    // [notification name] should always be @"PromotionListNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]]){
        NSDictionary *dictionary = notification.userInfo;
        _refreshTokenResponse = (RefreshTokenMetaMO*) dictionary[[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]];
        
        //Savign the access token
        [[NSUserDefaults standardUserDefaults]setObject:[_refreshTokenResponse accessToken] forKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]];
        [self refreshView];
    
    }else if ([[notification name] isEqualToString:[Constants GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION]]){
        NSDictionary *dictionary = notification.userInfo;
        _logoutResponseMO = (LogoutMetaMO*) dictionary[[Constants GET_LABEL_NAME_LOGOUT_RESPONSE]];
        [[self navigationController] popViewControllerAnimated:YES];
//        [self performSegueWithIdentifier:@"LogoutSegue" sender:self];
    }
}

#pragma mark - UIControlEventMethods
-(void)methodTouchUpInside:(id)sender{
    [self refreshWithAbstractFactory];
}


-(void)methodTouchLogoutButtonUpIndide{
//    [self logoutWithAbstractFactory];
    //UIAlertController configuration
    [self configureAlertControllerLogout];

}

#pragma mark - AlertController configuration
-(void) configureAlertControllerLogout{
    
    UIAlertAction *destroyAction;
    UIAlertAction *otherAction;
    
    _alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want log out?"
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    
    destroyAction = [UIAlertAction actionWithTitle:@"Log out"
                                             style:UIAlertActionStyleDestructive
                                           handler:^(UIAlertAction *action) {
                                               [self logoutWithAbstractFactory];
                                           }];
    
    otherAction = [UIAlertAction actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             [_alertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
    
    [_alertController addAction:destroyAction];
    [_alertController addAction:otherAction];
    [_alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    [self presentViewController:_alertController animated:YES completion:nil];
}




#pragma mark - Navigation
/**
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if( [[segue identifier] isEqualToString: @"LogoutSegue"]){
         [[self navigationController] popViewControllerAnimated:YES];
     }
 }
**/

@end
