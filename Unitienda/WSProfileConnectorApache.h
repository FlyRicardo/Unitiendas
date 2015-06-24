//
//  WSProfileConnectionApache.h
//  OAuthLoginSample
//
//  Created by Fly on 3/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSProfileConnector.h"

@interface WSProfileConnectorApache : NSObject<WSProfileConnector>

+(id)getInstance;

@end