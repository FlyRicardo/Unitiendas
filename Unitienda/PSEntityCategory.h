//
//  CategoryServices.h
//  Unitienda
//
//  Created by Fly on 6/19/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryMO.h"
#import "IconMO.h"

@protocol PSEntityCategory

-(CategoryMO*) getAllCategories;                            //Gives an array of (CategoryMO class) related with specific (StoreMO class), saved on the persistence application tool

-(IconMO*) getIconByCategory:(CategoryMO*) category;        //Gives an (IconMO class) object releted with specific (Category class) object, saved on the persistence application tool

@end