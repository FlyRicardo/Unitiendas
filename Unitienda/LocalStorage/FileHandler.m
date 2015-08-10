//
//  FileHandler.m
//  Unitienda
//
//  Created by Fly on 7/31/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "FileHandler.h"

@interface FileHandler()
@end

@implementation FileHandler

#pragma mark - Singleton routien

static FileHandler* _instance;

/**
 The runtime sends <initialize> to each class in a program just before the class,
 or any class that inherits from it, is sent its first message from within the program.
 
 The compiler sends the init request to its customize <init> method class,
 or the default <init>
 **/
+(void)initialize{
    if(self==[FileHandler class]){
        _instance = [[FileHandler alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
    }
    return self;
}

+(id) getInstance{
    return _instance;
}

#pragma mark - methods

/**
 *  Use to check if exist at leas one register on Promotion entity on CoreData. If it exists, it assume there are data on local model storage, since promotion are the heart of the model.
 **/
-(BOOL) checkExistingData:(NSManagedObjectContext*) managedObjectContext{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Promotion" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];

    
    NSError *error = nil;
    NSUInteger count = [managedObjectContext countForFetchRequest:request
                                                            error:&error];
    
    return (count != NSNotFound && count != 0) ? YES : NO;
}


@end