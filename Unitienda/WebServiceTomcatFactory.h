//
//  TomcatFactory.h
//  Unitienda
//
//  Created by Fly on 4/14/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceAbstracFactoryProtocol.h"

@interface WebServiceTomcatFactory : NSObject<WebServiceAbstracFactoryProtocol>

+(id)getInstance;

@end
