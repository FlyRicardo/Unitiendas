//
//  CacheManager.m
//  Ibiza
//
//  Created by Gabriel Bernal on 7/6/14.
//  Copyright (c) 2014 Falconlabs. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager

+(CacheManager*)sharedCacheController{
    static CacheManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        
    });
    return sharedManager;
}

-(id) init{
    self = [super init];
    
    if(self){
        _images = [[NSCache alloc] init];
    }
    
    return self;
}

-(UIImage*)getCachedImage:(NSString*)name{
    if(_images != nil && name != nil){
        return [_images objectForKey:name];
    }
    
    return nil;
}

-(void)setCachedImage:(UIImage*)image name:(NSString*)name{
    if(_images != nil && image != nil && name != nil){
        [_images setObject:image forKey:name];
    }
}

@end
