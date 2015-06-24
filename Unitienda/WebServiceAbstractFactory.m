//
//  WebServiceFactory.m
//  CC
//
//  Created by Fly on 11/25/14.
//  Copyright (c) 2014 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceAbstractFactory.h"

#import "WebServiceApacheFactory.h"
#import "WebServiceTomcatFactory.h"


@implementation WebServiceAbstractFactory

#pragma mark - Singleton Pattern implementation

static WebServiceAbstractFactory* _instance;

+(void)initialize{
    if(self == [WebServiceAbstractFactory class]){
        _instance = [[WebServiceAbstractFactory alloc]init];
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

#pragma mark - interface implementations

+(id<WSLoginConnector>) createWebServiceLoginConnection:(OutputTypes)type{
    
    switch (type) {
        case ApacheType:
        {
            return [WebServiceApacheFactory createWebServiceLoginConnection];//Method of Class
        }
        case TomcatType:
        {
            return [WebServiceTomcatFactory createWebServiceLoginConnection];//Method of Class

        }
            
        default:
            break;
    }
    return nil;
}


+(id<WSProfileConnector>) createWebServiceProfileConnection:(OutputTypes)type{
    
    switch (type) {
        case ApacheType:
        {
            return [WebServiceApacheFactory createWebServiceProfileConnection];
        }
        case TomcatType:
        {
            return [WebServiceTomcatFactory createWebServiceProfileConnection];
        }
            
        default:
            break;
    }
    
}

+(id<WSPromotionConnector>) createWebServicePromotionConnection:(OutputTypes)type{
    
    switch (type) {
        case ApacheType:
        {
            return [WebServiceApacheFactory createWebServicePromotionConnection];
        }
        case TomcatType:
        {
            return [WebServiceTomcatFactory createWebServicePromotionConnection];
        }
            
        default:
            break;
    }
    
}


@end