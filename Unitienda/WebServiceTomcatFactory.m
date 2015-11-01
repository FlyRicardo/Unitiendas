//
//  TomcatFactory.m
//  Unitienda
//
//  Created by Fly on 4/14/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "WebServiceTomcatFactory.h"

@implementation WebServiceTomcatFactory

#pragma mark - Singleton Pattern implementation

static WebServiceTomcatFactory* _instance;

+(void)initialize{
    if(self == [WebServiceTomcatFactory class]){
        _instance = [[WebServiceTomcatFactory alloc]init];
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
    return nil;
}

+(id<WSLoginConnector>) createWebServiceProfileConnection
{
    return nil;
}

+(id<WSPromotionConnector>) createWebServicePromotionConnection
{
    return nil;
}

+(id<WSArticleConnector>) createWebServiceArticleConnection{
    return nil;
}

@end
