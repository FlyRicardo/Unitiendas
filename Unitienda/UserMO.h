//
//  UserVO.h
//  Unitienda
//
//  Created by Fly on 4/27/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestMO.h"

@interface UserMO : RequestMO

@property(nonatomic) NSString* firstName;
@property(nonatomic) NSString* lastName;
@property(nonatomic) NSString* username;
@property(nonatomic) NSString* password;
@property(nonatomic) NSString* theNewPassword;

@end
