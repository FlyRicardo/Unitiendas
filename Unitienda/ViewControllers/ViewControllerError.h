//
//  ViewControllerError.h
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorizationAuthenticationMetaMO.h"
#import "ProfileMO.h"

@interface ViewControllerError : UIViewController

@property(strong,nonatomic) AuthorizationAuthenticationMetaMO* loginResponseMO;
@property(strong,nonatomic) ProfileMO* profileResponseMO;

@property (strong, nonatomic) IBOutlet UILabel *labelErrorDescription;
@property (strong, nonatomic) IBOutlet UITextView *textViewErrorDescription;

@end