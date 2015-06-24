//
//  WSConnection.h
//  CC
//
//  Created by Fly on 11/26/14.
//  Copyright (c) 2014 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface WSConnectionApache : NSObject

@property (nonatomic, strong) RKObjectManager *objectManager;

+(id)getInstance;

@end
