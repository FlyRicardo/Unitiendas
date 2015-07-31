//
//  LocalImageSaver.m
//  Unitienda
//
//  Created by Fly on 7/28/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ImageHandler.h"

@interface ImageHandler()

@property NSArray *paths;
@property NSString *documentsDirectory;

@end

@implementation ImageHandler

#pragma mark - Singleton routien

static ImageHandler* _instance;

/**
 The runtime sends <initialize> to each class in a program just before the class,
 or any class that inherits from it, is sent its first message from within the program.
 
 The compiler sends the init request to its customize <init> method class,
 or the default <init>
 **/
+(void)initialize{
    if(self==[ImageHandler class]){
        _instance = [[ImageHandler alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        _paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentsDirectory = [_paths objectAtIndex:0];
    }
    return self;
}

+(id) getInstance{
    return _instance;
}

#pragma mark - method

/**
 *  Private method.
 *  Use this method with an absolute URL from internet
 **/
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

/**
 *  Pulic private.
 *  Use to save an image locally using the path for local directories.
 **/
-(BOOL) saveImageLocallyWithFileName:(NSString *)imageName ofType:(NSString *)extension AndURL:(NSString*)fileURL{
    UIImage* image = [self getImageFromURL:fileURL];
    return [self saveImage:image withFileName:imageName ofType:extension inDirectory:_documentsDirectory];
}

/**
 *  Private method.
 *  Use this method to save an image given the file name, extensio, and directory path.
 *  Return YES, if the transaction was completed successfuly, and return no in other way.
 **/
-(BOOL) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        return [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        return [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        return false;
    }
}

/**
 *  Pulic method.
 *  Use to load a local image, given the name and the extension
 **/
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension {
    return [self loadImage:fileName ofType:extension inDirectory:_documentsDirectory];
}

/**
 *  Private method.
 *  Use to load an image given, the file name, the extension and directory path.
 **/
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    return result;
}

-(NSString *) getImageNameFromURL:(NSString*) url{
    NSArray* temp = [url componentsSeparatedByString:@"."];
    NSArray* temp2 = [[temp objectAtIndex:0] componentsSeparatedByString:@"/"];
    return [temp2 objectAtIndex:[temp2 count]-1];
}

-(NSString *) getExtensionFromURL:(NSString*) url{
    NSArray* temp = [url componentsSeparatedByString:@"."];
    return [temp objectAtIndex:1];
}

@end
