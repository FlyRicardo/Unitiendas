//
//  ViewControllerError.m
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerError.h"

@interface ViewControllerError()

@property (nonatomic)NSArray* viewArraysNavigationController;

@end

@implementation ViewControllerError

-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self configureNavigationBar];
    _viewArraysNavigationController = [[self navigationController] viewControllers];


    [_labelErrorDescription setText:[NSString stringWithFormat:@"%@ : %li", @"An error ocurred trying login", [_loginResponseMO code]]];
    
    if([_loginResponseMO errorDetail] != nil && ![[_loginResponseMO errorDetail] isEqualToString:@""]){
         [_textViewErrorDescription setText:[_loginResponseMO errorDetail]];
    }else{
//        [_textViewErrorDescription setText:[_profileResponseMO errorDetail]];
    }
}

-(void) viewWllDisappear:(BOOL)animated{
    //Removign the view from NavigationStack from UINavigationController
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void) viewDidDisappear:(BOOL)animated{
    //Removign the view from NavigationStack from UINavigationController
    [[self navigationController] popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavigationController configuration
//Hide the back-button on login frame
-(void) configureNavigationBar{
    //Hide the back-button on login frame
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end