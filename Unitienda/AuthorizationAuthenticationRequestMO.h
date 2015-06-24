//
//  LoginMO.h
//  OAuthLoginSample
//
//  Created by Fly on 3/9/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestMO.h"

@interface AuthorizationAuthenticationRequestMO : RequestMO

/**
 AUTHORIZATION BY USER_CREDETNIAL = PASSWORD , PARAMMETERS
**/
@property(nonatomic, strong) NSString* grantType;
@property(nonatomic, strong) NSString* clientId;
@property(nonatomic, strong) NSString* clientSecret;
@property(nonatomic, strong) NSString* username;
@property(nonatomic, strong) NSString* password;

@end
