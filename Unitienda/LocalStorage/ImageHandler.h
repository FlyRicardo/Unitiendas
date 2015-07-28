//
//  LocalImageSaver.h
//  Unitienda
//
//  Created by Fly on 7/28/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHandler : NSObject

-(BOOL) saveImageLocallyWithFileName:(NSString *)imageName ofType:(NSString *)extension AndURL:(NSString*)fileURL;
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension;

+(id) getInstance;

@end
