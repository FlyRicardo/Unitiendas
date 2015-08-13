//
//  Meta.h
//  Unitienda
//
//  Created by Fly on 8/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meta : NSManagedObject

@property (nonatomic, retain) NSNumber * code;
@property (nonatomic, retain) NSString * errorType;
@property (nonatomic, retain) NSString * errorDetail;

@end
