//
//  LoginResponseOM.h
//  OAuthLoginSample
//
//  Created by Fly on 3/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetaMO.h"

@interface AuthorizationAuthenticationMetaMO : MetaMO


/****************************************************************
 PARAMETERS OF SUCCESS CONNECTION
 ****************************************************************/
@property(nonatomic, strong) NSString* accessToken;
@property(nonatomic, strong) NSString* expiresIn;
@property(nonatomic, strong) NSString* tokenType;
@property(nonatomic, strong) NSString* scope;
@property(nonatomic, strong) NSString* refreshToken;


@end
