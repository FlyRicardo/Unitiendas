//
//  ResponseMO.h
//  OAuthLoginSample
//
//  Created by Fly on 3/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetaMO : NSObject

/****************************************************************
  PARAMETERS OF CODE RESPONSE
 ****************************************************************/
@property(nonatomic) NSInteger code;
@property(nonatomic, strong) NSString* errorType;
@property(nonatomic, strong) NSString* errorDetail;

@end
