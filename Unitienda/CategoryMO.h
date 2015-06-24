//
//  CategoryVO.h
//  Unitienda
//
//  Created by Fly on 4/27/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IconMO;

@interface CategoryMO : NSObject

@property (nonatomic) NSInteger categoryId;
@property (strong, nonatomic) NSString* name;
@property (nonatomic) NSInteger promotionCounts;
@property (strong, nonatomic) IconMO* iconMO;

@end
