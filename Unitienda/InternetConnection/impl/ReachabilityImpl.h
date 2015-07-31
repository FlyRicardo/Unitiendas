//
//  ReachabilityImpl.h
//  Unitienda
//
//  Created by Fly on 7/28/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityImpl : NSObject

-(BOOL) hostIsReachable;
-(BOOL) hostIsReachable2;
-(BOOL) internetIsReachable;
-(BOOL) wifiIsReachable;

+(id) getInstance;

@end
