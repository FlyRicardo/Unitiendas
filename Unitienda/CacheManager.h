//
//  CacheManager.h
//  Ibiza
//
//  Created by Gabriel Bernal on 7/6/14.
//  Copyright (c) 2014 Falconlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

@property (strong, nonatomic) NSCache *images;

+(CacheManager*)sharedCacheController;

-(UIImage*)getCachedImage:(NSString*)image;
-(void)setCachedImage:(UIImage*)image name:(NSString*)name;

@end
