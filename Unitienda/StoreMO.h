//
//  StoreVO.h
//  Unitienda
//
//  Created by Fly on 4/27/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMO.h"
#import "RequestMO.h"

@interface StoreMO : NSObject

@property (nonatomic) NSInteger storeId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* number;
@property (nonatomic) NSNumber* latitude;
@property (nonatomic) NSNumber* longitude;
@property (nonatomic) NSString* email;

@end
