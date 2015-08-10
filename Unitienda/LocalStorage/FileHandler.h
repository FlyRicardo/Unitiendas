//
//  FileHandler.h
//  Unitienda
//
//  Created by Fly on 7/31/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandler : NSObject

-(BOOL) checkExistingData:(NSManagedObjectContext*) managedObjectContext;
+(id) getInstance;

@end
