//
//  ReachabilityImpl.m
//  Unitienda
//
//  Created by Fly on 7/28/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "ReachabilityImpl.h"

@interface ReachabilityImpl()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation ReachabilityImpl


#pragma mark - Singleton routien

static ReachabilityImpl* _instance;

/**
 The runtime sends <initialize> to each class in a program just before the class,
 or any class that inherits from it, is sent its first message from within the program.
 
 The compiler sends the init request to its customize <init> method class,
 or the default <init>
 **/
+(void)initialize{
    if(self==[ReachabilityImpl class]){
        _instance = [[ReachabilityImpl alloc]init];
    }
}

-(id)init{
    self = [super init];
    if(self){
        NSString *remoteHostName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"ServiceLocalURL"];
        _hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        _internetReachability = [Reachability reachabilityForInternetConnection];
        _wifiReachability = [Reachability reachabilityForLocalWiFi];
    }
    return self;
}

+(id) getInstance{
    return _instance;
}

#pragma mark - Checking connectivity methods
/*!
 * Use to check the reachability of a given host name.
 */
-(BOOL) hostIsReachable{
    return ([_hostReachability currentReachabilityStatus] != NotReachable)?YES:NO;
}

/*!
 * Use to check the reachability of a given host name.
 */
-(BOOL) hostIsReachable2{
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:[NSURL URLWithString: @"http://localhost:82/CC/"]];
    NSHTTPURLResponse *response = nil;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:nsrequest returningResponse:&response error:&error];
    
    if(response.statusCode==0){
        return NO;
    }
    else{
        return YES;
    }
}

/*!
 * Use to check the reachability of a given IP address.
 */
-(BOOL) internetIsReachable{
    return ([_internetReachability currentReachabilityStatus] != NotReachable)?YES:NO;
}

/*!
 * Checks whether a local WiFi connection is available.
 */
-(BOOL) wifiIsReachable{
    return ([_wifiReachability currentReachabilityStatus] != NotReachable)?YES:NO;
}
@end
