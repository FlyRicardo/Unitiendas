//
//  WebServiceAbstracFactoryProtocol.h
//  Unitienda
//
//  Created by Fly on 4/14/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#ifndef Unitienda_WebServiceAbstracFactoryProtocol_h
#define Unitienda_WebServiceAbstracFactoryProtocol_h

#import "WSLoginConnector.h"
#import "WSProfileConnector.h"
#import "WSPromotionConnector.h"

@protocol WebServiceAbstracFactoryProtocol

+(id<WSLoginConnector>) createWebServiceLoginConnection;
+(id<WSProfileConnector>) createWebServiceProfileConnection;
+(id<WSPromotionConnector>) createWebServicePromotionConnection;

@end


#endif
