//
//  LogoutRequest.h
//  Unitienda
//
//  Created by Fly on 4/1/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestMO.h"

@interface LogoutRequestMO : RequestMO

@property(nonatomic, strong) NSString* accessToken;
@property(nonatomic, strong) NSString* refreshToken;

@end
