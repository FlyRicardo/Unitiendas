//
//  ViewControllerRegisterViewController.m
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ViewControllerRegister.h"
#import "ViewControllerHome.h"
#import "ViewControllerError.h"

#import "Constants.h"
#import "AuthorizationAuthenticationMetaMO.h"

@interface ViewControllerRegister ()

@end

@implementation ViewControllerRegister

- (void)viewDidLoad {
    [super viewDidLoad];
    [_acceptButton addTarget:self action:@selector(methodTouchUpInside:) forControlEvents:UIControlEventTouchDown];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(AuthorizationAuthenticationMetaMO*) registerCC
{
    //setting the string of the url
    NSString* urlString = @"http://127.0.0.1:82/my-oauth2-walkthrough/oauth2-server-php/src/register.php";
    
    //setting the body request with the parammeters as a string
    NSString *post = [NSString stringWithFormat:@"first_name=%@&last_name=%@&username=%@&password=%@&",
                      [_firstName text],
                      [_lastName text],
                      [_email text],
                      [_Password text]
                      ];
    
    //encoding the request body with NSASCIIString and wraper on NSData
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    
    //setting the header request as NSMutableURLRequest:
    //                                           URL:
    //                                           HttpMethod:
    //                                           HttpHeaderField:Content-Length
    //                                           HttpHeaderfield:Content-Type
    //                                           HttpBody:
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData]; //Setting the body of request
    
    
    //sending request as synchronousRequest, getting response
    NSError *error;
    NSHTTPURLResponse *response;
    NSData *urlData;
    AuthorizationAuthenticationMetaMO* loginResponseMO;
    
    urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Obtaning response parammeters
    NSInteger statusCode = [response statusCode];
    NSInteger errorCode = [error code];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    
    loginResponseMO = [[AuthorizationAuthenticationMetaMO alloc]init];
    [loginResponseMO setAccessToken:data];
    [loginResponseMO setCode:statusCode];
//    [loginResponseMO setErrorCode:errorCode];
    
    return loginResponseMO;
}

#pragma UIControlEventMethods
-(void)methodTouchUpInside:(id)sender{
    
    UIStoryboard *storyboard = self.storyboard;
    AuthorizationAuthenticationMetaMO *loginResponseMO = [self registerCC];
    
    //Parsing
    
    if([loginResponseMO code] == 200){
        ViewControllerHome *vch = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerHome"];
        [vch setLoginResponseMO:loginResponseMO];
        [self presentViewController:vch animated:YES completion:nil];
    }else{
        ViewControllerError *vce = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerError"];
        [vce setLoginResponseMO:loginResponseMO];
        [self presentViewController:vce animated:YES completion:nil];
    }
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
