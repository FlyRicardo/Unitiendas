//
//  WSLogin.m
//  OAuthLoginSample
//
//  Created by Fly on 3/9/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "WSLoginConnectorApache.h"
#import "WSConnectionApache.h"

#import "AuthorizationAuthenticationRequestMO.h"
#import "AuthorizationAuthenticationMetaMO.h"
#import "RefreshTokenRequestMO.h"
#import "RefreshTokenMetaMO.h"
#import "Constants.h"

#import "LogoutMetaMO.h"
#import "LogoutRequestMO.h"

@interface WSLoginConnectorApache()

@property (nonatomic, strong) WSConnectionApache *wsConnectionApache;

@end

@implementation WSLoginConnectorApache

#pragma mark - Singleton Pattern implementation

static WSLoginConnectorApache* _instance;

+(void)initialize{
    if(self == [WSLoginConnectorApache class]){
        _instance = [[WSLoginConnectorApache alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        
        //Initialite own parammeters
        
        //Object manager configuration
        _wsConnectionApache = [WSConnectionApache getInstance];
        
    }
    return self;
}

+(id)getInstance{
    return _instance;
}

#pragma mark - Protocol methos implementation
-(void) getLoginResponseWithUsername:(NSString*) username andPassword:(NSString*)password{
    
    //Todo: implement the RESTkit POST authorization
    
//    return [self stablishLoginConnectionWithUsername:username andPassword:password];
    [self stablishLoginConnectionThroughRestKitWithUsername:username andPassword:password];

}

-(void) refreshTokenWithRefreshToken:(NSString*)refreshToken{
    [self stablishRefreshTokenConnection:refreshToken];
}

-(void) executeLogout{
    [self executeLogoutExpiringTokens];
}

#pragma mark - get access-token without RESTkit
/**
 *
 EXAMPLE OF REQUEST FOR USER CREDENTIAL
 
 POST /token HTTP/1.1
 Host: server.example.com
 Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
 Content-Type: application/x-www-form-urlencoded
 
 grant_type=password&username=johndoe&password=A3ddj3w
 *
 **/
-(void) stablishLoginConnectionWithUsername:(NSString*)username andPassword:(NSString*)password{
    //setting the string of the url
    NSString* urlString = @"http://flyinc.co/my-oauth2-walkthrough/oauth2-server-php/src/token.php";
    
    //setting the body request with the parammeters as a string
    NSString* clientID = [Constants GET_CLIENT_ID];
    NSString* clientSecret = [Constants GET_CLIENT_SECRET];
    
    NSString *post = [NSString stringWithFormat:@"grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@&",
                      clientID,
                      clientSecret,
                      username,
                      password
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
    /**
    NSError *error;
    NSHTTPURLResponse *response;
    NSData *urlData;
    AuthorizationAuthenticationResponseMO *loginResponseMO;
    
    urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Obtaning response parammeters
    NSInteger statusCode = [response statusCode];
    NSInteger errorCode = [error code];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    

    ParserAuthorizationAuthentication* parserLogin = [[ParserAuthorizationAuthentication alloc]init];
    loginResponseMO =  [parserLogin fromJSONResponseToLoginOrRefreshTokenResponse:data];
    [loginResponseMO setStatusCode:statusCode];
    [loginResponseMO setErrorCode:errorCode];
     **/
}



#pragma mark - refresh-token
-(void) stablishRefreshTokenConnection:(NSString*)refreshToken{
 
    
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    NSString* clientID = [Constants GET_CLIENT_ID];
    NSString* clientSecret = [Constants GET_CLIENT_SECRET];
    NSString* grantType = [Constants GET_GRANT_TYPE_REFRESH_TOKEN];
    
    // Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"grantType":@"grant_type",
                                                         @"clientId":@"client_id",
                                                         @"clientSecret":@"client_secret",
                                                         @"refreshToken":@"refresh_token",
                                                         }];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[RefreshTokenRequestMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    RefreshTokenRequestMO* postBody = [[RefreshTokenRequestMO alloc]init];
    [postBody setGrantType: grantType];
    [postBody setClientId:clientID];
    [postBody setClientSecret:clientSecret];
    [postBody setRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"refresh_token"]];
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    
    //Object Mapping initiation
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[RefreshTokenMetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{ @"access_token" : @"accessToken",
                                                           @"expires_in":@"expiresIn",
                                                           @"token_type":@"tokenType",
                                                           @"scope": @"scope"
                                                           }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    //Adding response descripton
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] addResponseDescriptor:responseDescriptor];
    
    
    //Execute query
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/my-oauth2-walkthrough/oauth2-server-php/src/token.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray* loginResponse = nil;
                                               loginResponse = [result array];
                                               if([loginResponse count]>0){
                                                   if([[loginResponse objectAtIndex:0] isKindOfClass:[RefreshTokenMetaMO class]]){
                                                       RefreshTokenMetaMO* response = (RefreshTokenMetaMO*) [loginResponse objectAtIndex:0];

                                                       NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]: response};
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN] object:nil userInfo:userInfo];
                                                   }else{
                                                       NSLog(@"Error converting the response to AuthorizationAuthenticationResponseMO class");
                                                   }
                                               }else{
                                                   NSLog(@"Error, no object attached on response");
                                               }
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               RefreshTokenMetaMO* response = [[RefreshTokenMetaMO alloc]init];
                                               [NSString stringWithFormat:@"%li",(long)[error code]];
                                               [response setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE]: response};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];

}

#pragma mark - get access-token without RESTkit

-(void) stablishLoginConnectionThroughRestKitWithUsername:(NSString*)username andPassword:(NSString*)password{
    
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    //setting the body request with the parammeters as a string
    NSString* clientID = [Constants GET_CLIENT_ID];
    NSString* clientSecret = [Constants GET_CLIENT_SECRET];
    NSString* grantType = [Constants GET_GRANT_TYPE_USER_CREDENTIALS];
    
    // Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                        @"grantType":@"grant_type",
                                                         @"clientId":@"client_id",
                                                         @"clientSecret":@"client_secret",
                                                         @"username":@"username",
                                                         @"password":@"password"}];
    

    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[AuthorizationAuthenticationRequestMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    AuthorizationAuthenticationRequestMO* postBody = [[AuthorizationAuthenticationRequestMO alloc]init];
    [postBody setGrantType: grantType];
    [postBody setClientId:clientID];
    [postBody setClientSecret:clientSecret];
    [postBody setUsername:username];
    [postBody setPassword:password];

    
    /** 
     RESPONSE DESCRIPTIOR CONFIGURATION 
     **/
    //Object Mapping initiation
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[AuthorizationAuthenticationMetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{ @"access_token" : @"accessToken",
                                                           @"expires_in":@"expiresIn",
                                                           @"token_type":@"tokenType",
                                                           @"scope": @"scope",
                                                           @"refresh_token":@"refreshToken"
                                                           }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    

    //Adding response descripton
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager]addResponseDescriptor:responseDescriptor];
    
   
    
    //Execute query
    [[_wsConnectionApache objectManager]postObject:postBody
                        path:@"/my-oauth2-walkthrough/oauth2-server-php/src/token.php"
                  parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                    
                    NSArray* loginResponse = nil;
                    loginResponse = [result array];
                    if([loginResponse count]>0){
                        if([[loginResponse objectAtIndex:0] isKindOfClass:[AuthorizationAuthenticationMetaMO class]]){
                            AuthorizationAuthenticationMetaMO* response = (AuthorizationAuthenticationMetaMO*) [loginResponse objectAtIndex:0];
                            [response setCode:200];                                                                                                     //The OAuth2 json response donest has the meta content, this line bind the response code to object
                            NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_LOGIN_RESPONSE]: response};
                            [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                        }else{
                            NSLog(@"Error converting the response to AuthorizationAuthenticationResponseMO class");
                        }
                    }else{
                        NSLog(@"Error, no object attached on response");
                    }
                    
                }failure:^(RKObjectRequestOperation *operation, NSError *error){
                    
                    AuthorizationAuthenticationMetaMO* response = [[AuthorizationAuthenticationMetaMO alloc]init];
                    [NSString stringWithFormat:@"%li",(long)[error code]];
                    [response setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                    NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_LOGIN_RESPONSE]: response};
                    [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                    
                }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
}


#pragma mark - logout routine : expire access_token & refresh_token

-(void) executeLogoutExpiringTokens{
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    // Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"accessToken":@"access_token",
                                                         @"refreshToken":@"refresh_token"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[LogoutRequestMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    LogoutRequestMO* postBody = [[LogoutRequestMO alloc]init];
    [postBody setAccessToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    [postBody setRefreshToken:[[NSUserDefaults standardUserDefaults] valueForKey:[Constants GET_LABEL_NAME_REFRESH_TOKEN]]];
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    //Object Mapping initiation
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[LogoutMetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{ @"code" : @"code",
                                                           @"errorType":@"errorType",
                                                           @"errorDetail":@"errorDetail"
                                                           }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    //Adding response descripton
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager]addResponseDescriptor:responseDescriptor];
    
    //Execute query
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/my-oauth2-walkthrough/oauth2-server-php/src/expire_tokens.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray* logoutResponse = nil;
                                               logoutResponse = [result array];
                                               if([logoutResponse count]>0){
                                                   if([[logoutResponse objectAtIndex:0] isKindOfClass:[LogoutMetaMO class]]){
                                                       LogoutMetaMO* response = (LogoutMetaMO*) [logoutResponse objectAtIndex:0];

                                                       NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_LOGOUT_RESPONSE]: response};
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                                   }else{
                                                       NSLog(@"Error converting the response to LogoutResponseMO class");
                                                   }
                                               }else{
                                                   NSLog(@"Error, no object attached on response");
                                               }
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               LogoutMetaMO* response = [[LogoutMetaMO alloc]init];
                                               [NSString stringWithFormat:@"%li",(long)[error code]];
                                               [response setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_LOGOUT_RESPONSE]: response};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];
    
}



#pragma mark - change password

-(void) changePassword:(UserMO*) user{
    /**
     REQUEST DESCRIPTIOR CONFIGURATION
     **/
    
    // Construct a request mapping for our class
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"accessToken":@"access_token",
                                                         @"username":@"username",
                                                         @"password":@"current_password",
                                                         @"theNewPassword":@"new_password"
                                                         }];
    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[UserMO class]
                                                                                   rootKeyPath:nil
                                                                                        method:RKRequestMethodPOST];
    
    UserMO* postBody = [[UserMO alloc]init];
    [postBody setAccessToken:(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:[Constants GET_LABEL_NAME_ACCESS_TOKEN]]];
    [postBody setUsername: [user username]];
    [postBody setPassword: [user password]];
    [postBody setTheNewPassword:[user theNewPassword]];
    
    /**
     RESPONSE DESCRIPTIOR CONFIGURATION
     **/
    //Object Mapping initiation
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MetaMO class]];
    
    //Add Atributes to ObjectMapping
    [responseMapping addAttributeMappingsFromDictionary:@{ @"code" : @"code",
                                                           @"errorType":@"errorType",
                                                           @"errorDetail":@"errorDetail"
                                                           }];
    
    //Seting up response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:@"meta"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    //Adding response descripton
    [[_wsConnectionApache objectManager] addRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager]addResponseDescriptor:responseDescriptor];
    
    //Execute query
    [[_wsConnectionApache objectManager]postObject:postBody
                                              path:@"/CC/WS/WS_ChangePassword.php"
                                        parameters:nil
                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                                               
                                               NSArray* arrayResponse = nil;
                                               arrayResponse = [result array];
                                               if([arrayResponse count]>0){
                                                   if([[arrayResponse objectAtIndex:0] isKindOfClass:[MetaMO class]]){
                                                       MetaMO* response = (MetaMO*) [arrayResponse objectAtIndex:0];
                                                       
                                                       NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE]: response};
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                                   }else{
                                                       NSLog(@"Error converting the response to ResponseMO class");
                                                   }
                                               }else{
                                                   NSLog(@"Error, no object attached on response");
                                               }
                                               
                                           }failure:^(RKObjectRequestOperation *operation, NSError *error){
                                               
                                               MetaMO* response = [[MetaMO alloc]init];
                                               [NSString stringWithFormat:@"%li",(long)[error code]];
                                               [response setErrorDetail:[[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"]];
                                               NSDictionary* userInfo = @{[Constants GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE]: response};
                                               [[NSNotificationCenter defaultCenter] postNotificationName:[Constants GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION] object:nil userInfo:userInfo];
                                               
                                           }];
    
    //Flushing the request and response descriptors
    [[_wsConnectionApache objectManager] removeRequestDescriptor:requestDescriptor];
    [[_wsConnectionApache objectManager] removeResponseDescriptor:responseDescriptor];

}

//Once both flag varialbes _wasChangePasswordSuccsessFully and _wasCreateProfileSuccessfully are true, continue with the next SCENE

@end
