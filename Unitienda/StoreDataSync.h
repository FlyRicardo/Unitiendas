//
//  StoreDataSync.h
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreMO.h"

@protocol StoreDataSync

-(StoreMO*) getStoreProfile:(StoreMO*) store usingWSRequest:(BOOL) flag;;             //Depends on the flag, the method use WS to get Store Profile and store it on local DB ( if flag is true ), or only get an Store Profile from local DB ( if flag is false )
@end