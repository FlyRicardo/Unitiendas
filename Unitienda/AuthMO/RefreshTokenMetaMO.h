//
//  RefreshTokenResponseMO.h
//  OAuthLoginSample
//
//  Created by Fly on 3/25/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "MetaMO.h"

@interface RefreshTokenMetaMO : MetaMO


/****************************************************************
 PARAMETERS OF SUCCESS CONNECTION
 ****************************************************************/
@property(nonatomic, strong) NSString* accessToken;
@property(nonatomic, strong) NSString* expiresIn;
@property(nonatomic, strong) NSString* tokenType;
@property(nonatomic, strong) NSString* scope;

@end
