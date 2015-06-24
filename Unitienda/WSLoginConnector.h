//
//  WSLoginConnection.h
//  OAuthLoginSample
//
//  Created by Fly on 3/10/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorizationAuthenticationMetaMO.h"
#import "UserMO.h"


@protocol WSLoginConnector

-(void) getLoginResponseWithUsername:(NSString*) username andPassword:(NSString*)password;      //Notification for attempting of authentication proccess
                                                                                                //Params: Success @AuthorizationAuthenticationMetaMO class
                                                                                                //        Failure @AuthorizationAuthenticationMetaMO class

-(void) refreshTokenWithRefreshToken:(NSString*) refreshToken;                                  //Notification for request new access_token given a refresh_token proccess
                                                                                                //Params: Success @RefreshTokenMetaMO class
                                                                                                //        Failure @RefreshTokenMetaMO class

-(void) executeLogout;                                                                          //Notification for attempting of finish session of user
                                                                                                //Params: Success @LogoutMetaMO class
                                                                                                //        Failure @LogoutMetaMO class

-(void) changePassword:(UserMO*) user;                                                          //Notification for attempting of changing password
                                                                                                //Params: Success @MetaMO class
                                                                                                //        Failure @MetaMO class

@end
