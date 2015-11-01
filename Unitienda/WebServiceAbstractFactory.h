//
//  WebServicesFactory.h
//  CC
//
//  Created by Fly on 11/25/14.
//  Copyright (c) 2014 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSLoginConnector.h"
#import "WSProfileConnector.h"
#import "WSPromotionConnector.h"
#import "WSArticleConnector.h"

typedef enum ouputTypes {
    ApacheType,
    TomcatType
} OutputTypes;

@interface WebServiceAbstractFactory : NSObject

+(id<WSLoginConnector>) createWebServiceLoginConnection:(OutputTypes)type;
+(id<WSProfileConnector>) createWebServiceProfileConnection:(OutputTypes)type;
+(id<WSPromotionConnector>) createWebServicePromotionConnection:(OutputTypes)type;
+(id<WSArticleConnector>) createWebServiceArticleConnection:(OutputTypes)type;

+(id)getInstance;

@end



