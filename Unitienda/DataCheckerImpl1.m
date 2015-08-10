//
//  DataCheckerImpl1.m
//  Unitienda
//
//  Created by Fly on 7/31/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "DataCheckerImpl1.h"
#import "FileHandler.h"

@implementation DataCheckerImpl1

#pragma mark - Singleton Pattern implementation
static DataCheckerImpl1* _instance;

+(void)initialize{
    if(self == [DataCheckerImpl1 class]){
        _instance = [[DataCheckerImpl1 alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        //Initialite own parammeters
        //Object manager configuration
    }
    return self;
}

+(id)getInstance{
    return _instance;
}

#pragma mark - Protocol methos implementation
-(BOOL) hasData:(NSManagedObjectContext*)managedObjectContext{
    return [[FileHandler getInstance] checkExistingData:managedObjectContext];
}

@end
