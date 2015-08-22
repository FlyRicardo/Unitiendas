//
//  Constants.h
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

/****************************************************************
 CONSTANT CONNECTIONS
 ****************************************************************/
+(NSString *) GET_CLIENT_ID;
+(NSString *) GET_CLIENT_SECRET;
+(NSInteger) GET_CONNECTION_TYPE_APACHE;
+(NSInteger) GET_CONNECTION_TYPE_TOMCAT;
+(NSString*) GET_GRANT_TYPE_USER_CREDENTIALS;
+(NSString*) GET_GRANT_TYPE_REFRESH_TOKEN;

/****************************************************************
 LOGIN CONSTANTS
****************************************************************/
+(NSString *) GET_LABEL_NAME_ACCESS_TOKEN;
+(NSString *) GET_LABEL_NAME_EXPIRES_IN;
+(NSString *) GET_LABEL_NAME_TOKEN_TYPE;
+(NSString *) GET_LABEL_NAME_SCOPE;
+(NSString *) GET_LABEL_NAME_REFRESH_TOKEN;
+(NSString *) GET_LABEL_NAME_LOGIN_RESPONSE;
+(NSString *) GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION;
+(NSString *) GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE;
+(NSString *) GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN;
+(NSString *) GET_LABEL_NAME_LOGOUT_RESPONSE;
+(NSString *) GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION;

/****************************************************************
 PROFILE CONSTANTS
 ****************************************************************/
+(NSString *) GET_LABEL_NAME_PROFILE_RESPONSE;
+(NSString *) GET_LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION;
+(NSString *) GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE;
+(NSString *) GET_LABEL_NAME_PROFILE_CREATOR_UPDATER_RESPONSE_NOTIFICATION;
+(NSString *) GET_LABEL_NAME_PROFILE_STORE_RESPONSE;
+(NSString *) GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION;
+(NSString *) GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE;
+(NSString *) GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION;
+(NSString *) GET_LABEL_STORE_ID;
+(NSString *) GET_LABEL_STORE_NAME;
+(NSString *) GET_LABEL_USER_NAME;
+(NSString *) GET_LABEL_FIRST_NAME;
+(NSString *) GET_LABEL_LAST_NAME;
+(NSString *) GET_ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE;
+(NSString *) GET_ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE;
+(NSString *) GET_ERROR_FOUND_STORE_BY_ID;


/****************************************************************
 PROMOTION CONSTANTS
 ****************************************************************/
+(NSString *) GET_LABEL_NAME_PROMOTIONS_BY_STORE_WS_RESPONSE_NOTIFICATION;
+(NSString *) GET_LABEL_NAME_PROMOTIONS_BY_STORE_WS_RESPONSE;


/****************************************************************
 CONSTANT DICTIONARY
 ****************************************************************/
+(NSArray*) GET_NUMBER_STORES;
+(NSDictionary*) GET_POSITION_DICTIONARY_STORE_NUMBER_AS_KEY;
+(NSDictionary*) GET_POSITION_DICTIONARY_ORIGIN_LAYER_AS_KEY;

@end
