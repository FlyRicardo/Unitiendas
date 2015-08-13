//
//  ViewControllerHome.h
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorizationAuthenticationMetaMO.h"
#import "ProfileMO.h"

@interface ViewControllerHome : UIViewController

@property(strong,nonatomic) AuthorizationAuthenticationMetaMO* loginResponseMO;
@property(strong,nonatomic) ProfileMO* profileResponseMO;

//Header
@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UILabel *accessTokenLabel;
@property (strong, nonatomic) IBOutlet UITextView *resultValidationTokenTextView;

@property (strong, nonatomic) IBOutlet UIButton *usingTokenButton;


-(void)refreshView;

@end
