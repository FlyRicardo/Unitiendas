//
//  DataSyncServiceImpl2.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSyncServiceAbstractFactoryProtocol.h"

@interface DataSyncServiceFactoryImpl2 : NSObject<DataSyncServiceAbstractFactoryProtocol>

+(id)getInstance;

@end
