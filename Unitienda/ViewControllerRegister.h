//
//  ViewControllerRegisterViewController.h
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerRegister : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *Password;
@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) IBOutlet UIButton *acceptButton;

@end
