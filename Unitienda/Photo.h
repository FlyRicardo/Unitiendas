//
//  Photo.h
//  Unitienda
//
//  Created by Fly on 7/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * photoId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Article *article;

@end
