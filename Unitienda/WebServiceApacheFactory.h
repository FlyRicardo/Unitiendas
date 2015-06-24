//
//  ApacheFactory.h
//  CC
//
//  Created by Fly on 11/25/14.
//  Copyright (c) 2014 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceAbstracFactoryProtocol.h"

@interface WebServiceApacheFactory : NSObject<WebServiceAbstracFactoryProtocol>

+(id)getInstance;

@end
