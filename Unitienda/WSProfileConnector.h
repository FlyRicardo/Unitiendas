//
//  WSProfileConnection.h
//  OAuthLoginSample
//
//  Created by Fly on 3/24/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileMO.h"

#import "UserMO.h"
#import "Store.h"

@protocol WSProfileConnector

-(void) createProfileWithStoreInfo:(Store*) store;            //Notify request for creation profile status,
                                                                //Params: Success @Meta class
                                                                //        Failure @Meta class

-(void) updateProfileWithStoreInfo:(Store*) store;            //Notify request for creation profile status,
                                                              //Params: Success @Meta class
                                                              //        Failure @Meta class


-(void) getProfielResponseMOWithUsername:(NSString*)username;   //Notify to its selector the status of request for profile
                                                                //Params: Success NSArray {@Meta class, @ProfileStore class}
                                                                //        Failure @Meta class


-(void) getProfileStore:(NSString*) email;                      //Notify to its selector the status of request of check profile store
                                                                //Params: Success NSArray {@Meta class, @ProfileStore class}
                                                                //        Failure @Meta class

@end