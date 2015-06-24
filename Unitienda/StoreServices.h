//
//  StoreServices.h
//  Unitienda
//
//  Created by Fly on 6/19/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreMO.h"

@protocol StoreServices

-(StoreMO*) getStoreProfile:(StoreMO*) store;             //Gives an (StoreMO class) object related with specific (StoreMO class) attributes, saved on the persistence application tool

@end