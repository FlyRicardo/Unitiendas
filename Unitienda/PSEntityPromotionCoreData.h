//
//  EntityPromotionPersistance.h
//  Unitienda
//
//  Created by Fly on 6/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSEntityPromotion.h"

@interface PSEntityPromotionCoreData : NSObject<PSEntityPromotion>
    +(id)getInstance;
@end
