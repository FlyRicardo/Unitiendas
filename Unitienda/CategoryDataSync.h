//
//  CategoryDataSync.h
//  Unitienda
//
//  Created by Fly on 7/2/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryMO.h"
#import "IconMO.h"

@protocol CategoryDataSync

-(CategoryMO*) getAllCategoriesUsingWSRequest:(BOOL) flag;;                            //Depends on the flag, the method use WS to get All Categories and store it on local DB ( if flag is true ), or only get an Store Profile from local DB ( if flag is false )

-(IconMO*) getIconByCategory:(CategoryMO*) category usingWSRequest:(BOOL) flag;;        //Depends on the flag, the method use WS to get Icon By Category and store it on local DB ( if flag is true ), or only get an Icon By Category from local DB ( if flag is false )

@end