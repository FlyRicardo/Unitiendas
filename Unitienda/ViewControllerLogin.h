//
//  ViewController.h
//  OAuthLoginSample
//
//  Created by Fly on 2/20/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerLogin : UIViewController<NSURLConnectionDelegate,UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *logginButton;

@property (strong, nonatomic) IBOutlet UIButton *forgotPassButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

