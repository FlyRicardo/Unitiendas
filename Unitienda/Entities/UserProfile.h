//
//  UserProfile.h
//  Unitienda
//
//  Created by Fly on 8/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Meta.h"

@class Store;

@interface UserProfile : Meta

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * refreshToken;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) Store *store;

@end
