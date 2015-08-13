//
//  ViewController.m
//  OAuthLoginSample
//
//  Created by Fly on 2/20/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerLogin.h"
#import "ViewControllerPromotionList.h"
#import "ViewControllerCreateEditProfile.h"

#import "Constants.h"

#import "AuthorizationAuthenticationMetaMO.h"
#import "ProfileMO.h"
#import "RefreshTokenMetaMO.h"
#import "StoreMO.h"
#import "MetaMO.h"
#import "ProfileMO.h"

#import "WebServiceAbstractFactory.h"

static NSString *kSegueIdentifierCreateProfile = @"ViewControllerCreateProfileSegue";
static NSString *kSegueIdentifierPromotionList = @"ViewControllerPromotionListSegue";

@interface ViewControllerLogin () //CLASS EXTENSION

@property (weak, nonatomic) AuthorizationAuthenticationMetaMO* loginResponseMO;
@property (weak, nonatomic) RefreshTokenMetaMO* refreshTokenResponseMO;

@property id wsProfileConnection;
@property id wsLoginConnection;

@property (weak,nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation ViewControllerLogin

-(void) viewWillAppear:(BOOL)animated{
    
    [self configureNavigationBar];
    
    [_usernameTextField setText:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_USER_NAME]]];
    [_passwordTextField setText:@""];
    
    [self registerForKeyboardNotifications];    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self registerNotifyProcess];
    [self initPropertiesView];
    
    NSLog(@"The access_token store : %@",[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]);
    
    if([self hasUserCredentials]){
        
        //Put an spin waitter while receive the notification of profile, and call the profile routine
        [self configureActivityIndicatorWithFlag:true];
        
        [_wsProfileConnection getProfielResponseMOWithUsername:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_USER_NAME]]];
        
    }else{
        
        //Hide the activity indicator
        [self configureActivityIndicatorWithFlag:false];
        
        //Execute the normal flow of: First time loggin, or Refresh_Token expired
        //Register the notification proccess of complete keyboard behavior
        [self registerForKeyboardNotifications];
        
        //Setting default username
        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_USER_NAME]];
        if(username &&  ![username isEqualToString:@""]){
            [_usernameTextField setText:username];
        }
    }
    
}

-(void) viewDidAppear:(BOOL)animated
{
}

-(void) viewWillDisappear:(BOOL)animated
{

    [self unregisterNotifyProcess];
    [self unregisterForKeyboardNotifications];
}

-(void) viewDidDisappear:(BOOL)animated
{
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initPropertiesView{


    
    //Create WS LogginConnection product with the AbstractFactory
    _wsLoginConnection =  [WebServiceAbstractFactory createWebServiceLoginConnection:ApacheType];
    
    // Create  WS Profile product with the AbstractFactory
    _wsProfileConnection =  [WebServiceAbstractFactory createWebServiceProfileConnection:ApacheType];
    
    [_logginButton addTarget:self action:@selector(methodTouchUpInside:) forControlEvents:UIControlEventTouchDown];
}

#pragma mark - routine of Login

/** If the access_token store on NSUserDefaults are still available, then execute the WS Profile connection **/
-(Boolean) hasUserCredentials{
    NSString* storeUsername = [[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_USER_NAME]];
    NSString* storeAccessToken = [[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]];
    if((storeUsername && ![storeUsername isEqualToString:@""]) && (storeAccessToken && ![storeAccessToken isEqualToString:@""]) ){
        return true;
    }else{
        return false;
    }
}

-(void) loginWithAbstractFactory
{
    //Register the notification proccess of complete the fetching data
   [_wsLoginConnection getLoginResponseWithUsername: [_usernameTextField text] andPassword:[_passwordTextField text]];
}


#pragma mark - NavigationController configuration

-(void) configureNavigationBar{
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //The index of View controllers, for this case, should be : 1 , or the second view Added to the Navigation Controler
    UINavigationController *navigationController = [self.navigationController.viewControllers lastObject];
    UINavigationBar *navigationBar =[[navigationController navigationController] navigationBar];
    UINavigationItem* navigationItem = [navigationController navigationItem];
    
    [navigationBar setBackgroundColor:[UIColor yellowColor]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [navigationItem setTitle: @"Login"];
}

#pragma mark - Spping waiter
-(void) configureActivityIndicatorWithFlag:(Boolean) shouldShowed
{
    if(shouldShowed){
        [self.view setUserInteractionEnabled:NO];
        [self.activityIndicator startAnimating];
    }else{
        [self.view setUserInteractionEnabled:YES];
        [self.activityIndicator stopAnimating];
    }
}


#pragma mark - Notifying Web Service proccess

-(void)registerNotifyProcess{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLoginNotification:)
                                                 name:[Constants GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveProfileNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedProfileStoreNotification:)
                                                 name:[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRefreshNotification:)
                                                 name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
                                               object:nil];
    
}

-(void) unregisterNotifyProcess{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                   name:[Constants GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION]
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Constants GET_LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION]
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN]
                                               object:nil];
}


/**
 *  Use this method to revceive notification of web service loggin. Here is not considered the expire_token, since it is a direct connection with the web service.
 **/
-(void)receiveLoginNotification:(NSNotification *) notification{
    
    NSDictionary *dictionary = notification.userInfo;
    _loginResponseMO = (AuthorizationAuthenticationMetaMO*) dictionary[[Constants GET_LABEL_NAME_LOGIN_RESPONSE]];
    
    if([_loginResponseMO code] == 200){
        
        //Save the access and refresh token, and username
        [[NSUserDefaults standardUserDefaults]setObject:[_loginResponseMO accessToken]
                                                 forKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]];
        
        [[NSUserDefaults standardUserDefaults]setObject:[_loginResponseMO refreshToken]
                                                 forKey:[Constants GET_LABEL_NAME_REFRESH_TOKEN]];
        
        [[NSUserDefaults standardUserDefaults]setObject:[_usernameTextField text]
                                                 forKey:[Constants GET_LABEL_USER_NAME]];
        
        //Instantiating view Controller with identifier (programatically
        /**
         UIStoryboard *storyboard = self.storyboard;
         ViewControllerHome *vch = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerHome"];
         [[vch loginResponseMO]setAccessToken:[_response reseponseBody]];
         [self presentViewController:vch animated:YES completion:^{
         [vch setLoginResponseMO:[[LoginResponseMO alloc]init]];
         [[vch loginResponseMO]setUsername:[_usernameTextField text]];
         [[vch loginResponseMO] setAccessToken:[_response reseponseBody]];
         [vch refreshView];
         }];
         **/
        
        //Instantiating view Controller with identifier
        /**
         ViewControllerError *vce = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerError"];
         vce.errorDescription = [NSString stringWithFormat:@"%ld",(long)_response.errorCode];
         [self presentViewController:vce animated:YES completion:nil];
         **/
        [_wsProfileConnection getProfielResponseMOWithUsername:[[NSUserDefaults standardUserDefaults]
                                                                valueForKey:[Constants GET_LABEL_USER_NAME]]];
        
    }else {
        
        
        [self configureActivityIndicatorWithFlag:false];                                                        //Remove the activity indicator
        
        [self showAlertController:                                                                              //Alert controller showing error
         [NSString stringWithFormat:@"%li: \n %@",[_loginResponseMO code], [_loginResponseMO errorDetail]]
                            Segue:@""];
        
    }
}

-(void)receiveProfileNotification:(NSNotification *) notification{
    
    NSDictionary *dictionary = notification.userInfo;
    if([dictionary[[Constants GET_LABEL_NAME_PROFILE_RESPONSE]] isKindOfClass:[NSArray class]]){                    //If the dictionary is an Array,
                                                                                                                    //it means it was a successful connection
        NSArray* profileResponse = dictionary[[Constants GET_LABEL_NAME_PROFILE_RESPONSE]];
        MetaMO *meta;
        if([profileResponse count] == 1 &&
           [[profileResponse objectAtIndex:0] isKindOfClass:[MetaMO class]]){                                      //If the response has strictly 1 object attached,
                                                                                                                   //it means it was a error server response (only meta: root)
            meta = [profileResponse objectAtIndex:0];
            
            if([[meta errorDetail] containsString:[Constants GET_ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE]]){          //If the error was related with expire token,
                                                                                                                    //call refresh_token
                
                [_wsLoginConnection refreshTokenWithRefreshToken:
                 [[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_REFRESH_TOKEN]]];
                
            }else{
                
                [self showAlertController:                                                                          //Alert controller showing error
                 [NSString stringWithFormat:@"%li: \n %@", [meta code], [meta errorDetail]]
                                    Segue:@""];
                
            }
            

            
        }else if([profileResponse count] >1){                                                                       //If the response has more than 1 object attached,
                                                                                                                    //it means it was a success server response
            int indexMeta = 0;
            int indexProfileMO = 0;
            
            if([[profileResponse objectAtIndex:0] isKindOfClass:[MetaMO class]]){                                   //The response of WS is changing the order of Meta and Profile, so it's neccessary has clarity about the index
                indexMeta = 0;
                indexProfileMO = 1;
                
            }else{
                indexMeta = 1;
                indexProfileMO = 0;
            }
            
            meta = (MetaMO*)[profileResponse objectAtIndex:indexMeta];
            if([meta code] == 200){
                if([[profileResponse objectAtIndex:indexProfileMO] isKindOfClass:[ProfileMO class]]){
                    
                    ProfileMO *profile = [profileResponse objectAtIndex:indexProfileMO];
                    [[NSUserDefaults standardUserDefaults]setObject:[profile firstName]
                                                             forKey:[Constants GET_LABEL_FIRST_NAME]];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:[profile lastName]
                                                             forKey:[Constants GET_LABEL_LAST_NAME]];
                    
                    [_wsProfileConnection getProfileStore:[[NSUserDefaults standardUserDefaults]
                                                           valueForKey:[Constants GET_LABEL_USER_NAME]]];            //Call the store profile,
                                                                                                                     //with the user name has already store
                }
            }
            
        }
    }else{                                                                                                          //If the dictionary is not an Array,
                                                                                                                    //it means it was an error connection
        MetaMO* meta = dictionary[[Constants GET_LABEL_NAME_PROFILE_RESPONSE]];
        [self configureActivityIndicatorWithFlag:false];                                                            //Remove the activity indicator
        [self showAlertController:                                                                                  //Alert controller showing error
         [NSString stringWithFormat:@"%li: \n %@", [meta code], [meta errorDetail]]
                            Segue:@""];
    }
}

-(void) receivedProfileStoreNotification:(NSNotification*) notification{
    
    [self configureActivityIndicatorWithFlag:false];                                                                //Remove spin waitter while receive the notification of profile
 
    NSDictionary *dictionary = notification.userInfo;
    if([dictionary[[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE]] isKindOfClass:[NSArray class]]){              //If the dictionary is an Array,
                                                                                                                    //it means it was a successful connection
        NSArray* profileStoreResponse = dictionary[[Constants GET_LABEL_NAME_PROFILE_STORE_RESPONSE]];
        MetaMO *meta;
        StoreMO *store;
        
        if([profileStoreResponse count] == 1 &&
           [[profileStoreResponse objectAtIndex:0] isKindOfClass:[MetaMO class]]){                                  //If the response has strictly 1 object attached,
                                                                                                                    //it means it was a error server response (only meta: root)

            meta = [profileStoreResponse objectAtIndex:0];
            
            if([[meta errorDetail] containsString:[Constants GET_ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE]]){          //If the error was related with expire token,
                //call refresh_token
                
                [_wsLoginConnection refreshTokenWithRefreshToken:
                 [[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_REFRESH_TOKEN]]];
                
            }else if([[meta errorDetail] containsString:[Constants GET_ERROR_FOUND_STORE_BY_ID]]){
                
                [self showAlertController:@"Para crear promociones es necesario que primero cree el perfil de su local." //Alert controller, indicating create profile store mandatory
                                    Segue:@"ViewControllerCreateProfileSegue"];
                
            }else{
                [self showAlertController:                                                                              //Alert controller showing error
                 [NSString stringWithFormat:@"%li: \n %@", [meta code], [meta errorDetail]]
                                    Segue:@""];
            }
            
        }else if([profileStoreResponse count] >1){
            
            //If the response has more than 1 object attached,
            meta = [profileStoreResponse objectAtIndex:0];
            store = [profileStoreResponse objectAtIndex:1];
            
                                                                                                                    //it means it was a success server response
            if ([meta code] == 200){
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:[store storeId]]
                                                         forKey:[Constants GET_LABEL_STORE_ID]];
                [[NSUserDefaults standardUserDefaults]setObject:[store name]
                                                         forKey:[Constants GET_LABEL_STORE_NAME]];
                
                [self performSegueWithIdentifier:kSegueIdentifierPromotionList sender:self];
            }else{
                [self showAlertController:                                                                          //Alert controller showing error
                [NSString stringWithFormat:@"%li: \n %@", [meta code], [meta errorDetail]]
                                    Segue:@""];
            }
        }
    }else{                                                                                                          //If the dictionary is not an Array,
                                                                                                                    //it means it was an error connection
        MetaMO* meta = dictionary[[Constants GET_LABEL_NAME_PROFILE_RESPONSE]];
        
        [self showAlertController:                                                                                  //Alert controller showing error
         [NSString stringWithFormat:@"%li: \n %@", [meta code], [meta errorDetail]]
                            Segue:@""];
        
    }

}

-(void)receiveRefreshNotification:(NSNotification *) notification{
    NSDictionary *dictionary = notification.userInfo;
    _refreshTokenResponseMO = (RefreshTokenMetaMO*) dictionary[[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]];
    
    if([[_refreshTokenResponseMO errorDetail] containsString: [Constants GET_ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE] ]){      //Refresh token has expired. The authentication proccess has to star again.
        [self configureActivityIndicatorWithFlag:false];
    }else if([_refreshTokenResponseMO code] == 0){         //Not error reported
        
        [[NSUserDefaults standardUserDefaults]setObject:[_refreshTokenResponseMO accessToken] forKey:@"access_token"];               //Save the access and refresh token, and username
        
        [_wsProfileConnection getProfielResponseMOWithUsername:[_usernameTextField text]];                                           //Start again the request to get profile of user
    }
    
    
}

#pragma mark - UIAlert View Controllers
-(void) showAlertController:(NSString*) title Segue:(NSString*) segue{
    
    [self configureActivityIndicatorWithFlag:false];
    
    UIAlertAction *destroyAction;
    
    UIAlertController * alertController= [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    destroyAction = [UIAlertAction actionWithTitle:@"Aceptar"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                              
                                               if(![segue isEqualToString:@""]){
                                                   [self performSegueWithIdentifier:segue sender:self];            //Call ViewControllerCreateProfile
                                               }
                                               /**[self performSegueWithIdentifier:@"ViewControllerHomeSegue" sender:self];**/
                                           }];
    
    [alertController addAction:destroyAction];
    [alertController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - UIControlEventMethods
-(void)methodTouchUpInside:(id)sender{
    
    //Put an spin waitter while receive the notification of profile, and call the profile routine
    [self configureActivityIndicatorWithFlag:true];
    
    [self loginWithAbstractFactory];
}

#pragma mark - Navigation programatically
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString: kSegueIdentifierCreateProfile]){
        
        ViewControllerCreateEditProfile *viewController = [segue destinationViewController];
        [viewController setManagedObjectContext:self.managedObjectContext];
        [viewController setCreationMode:YES];
        
    }else if([[segue identifier] isEqualToString: kSegueIdentifierPromotionList]){
        
        NSLog(@"Go to Create Promotion List Segue");
        ViewControllerPromotionList *viewController = [segue destinationViewController];
        [viewController setManagedObjectContext:self.managedObjectContext];
        
    }
}

#pragma mark - KeyBoard notifications & effects
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)unregisterForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)keyboardWasShown:(NSNotification*)aNotification                             // Called when the UIKeyboardDidShowNotification is sent.
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+100, 0.0);//The addition of 40 is to appearing the password text field
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification                        // Called when the UIKeyboardWillHideNotification is sent
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - storign the active field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

@end
