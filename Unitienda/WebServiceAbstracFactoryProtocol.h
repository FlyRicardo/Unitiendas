//
//  WebServiceAbstracFactoryProtocol.h
//  Unitienda
//
//  Created by Fly on 4/14/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "WSLoginConnector.h"
#import "WSProfileConnector.h"
#import "WSPromotionConnector.h"
#import "WSArticleConnector.h"

@protocol WebServiceAbstracFactoryProtocol

+(id<WSLoginConnector>) createWebServiceLoginConnection;
+(id<WSProfileConnector>) createWebServiceProfileConnection;
+(id<WSPromotionConnector>) createWebServicePromotionConnection;
+(id<WSArticleConnector>) createWebServiceArticleConnection;

@end