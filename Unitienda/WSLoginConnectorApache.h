//
//  WSLogin.h
//  OAuthLoginSample
//
//  Created by Fly on 3/9/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSLoginConnector.h"

@interface WSLoginConnectorApache : NSObject<WSLoginConnector>

+(id)getInstance;

@end
