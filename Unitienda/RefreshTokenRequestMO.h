//
//  RefreshTokenMO.h
//  OAuthLoginSample
//
//  Created by Fly on 3/25/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "RequestMO.h"

@interface RefreshTokenRequestMO : RequestMO

@property(nonatomic, strong) NSString* grantType;
@property(nonatomic, strong) NSString* clientId;
@property(nonatomic, strong) NSString* clientSecret;
@property(nonatomic, strong) NSString* refreshToken;


@end
