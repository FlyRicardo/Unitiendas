//
//  Icon.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryClassification;

@interface Icon : NSManagedObject

@property (nonatomic, retain) NSNumber * iconId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) CategoryClassification *category;

@end
