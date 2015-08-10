//
//  DataSyncServiceImpl1.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSyncServiceAbstractFactoryProtocol.h"


/**
 * This concrete factory represents the CoreData Implementation
 **/
@interface DataSyncServiceFactoryImpl1 : NSObject<DataSyncServiceAbstractFactoryProtocol>

+(id)getInstance;

@end
