//
//  ApacheFactory.m
//  CC
//
//  Created by Fly on 11/25/14.
//  Copyright (c) 2014 ___FlyInc___. All rights reserved.
//

#import "WebServiceApacheFactory.h"
#import "WSLoginConnectorApache.h"
#import "WSProfileConnectorApache.h"
#import "WSPromotionConnectorapache.h"

@implementation WebServiceApacheFactory

#pragma mark - Singleton Pattern implementation

static WebServiceApacheFactory* _instance;

+(void)initialize{
    if(self == [WebServiceApacheFactory class]){
        _instance = [[WebServiceApacheFactory alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        //Initialite own parammeters
    }
    return self;
}

+(id)getInstance{
    return _instance;
}


#pragma mark - Protocol methos implementation

+(id<WSLoginConnector>) createWebServiceLoginConnection
{
    return[WSLoginConnectorApache getInstance];
}

+(id<WSProfileConnector>) createWebServiceProfileConnection
{
    return[WSProfileConnectorApache getInstance];
}

+(id<WSPromotionConnector>) createWebServicePromotionConnection
{
    return[WSPromotionConnectorApache getInstance];
}

@end
