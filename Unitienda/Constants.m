//
//  Constants.m
//  OAuthLoginSample
//
//  Created by Fly on 3/3/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "Constants.h"
#import <UIKit/UIKit.h>

@implementation Constants

/****************************************************************
 CONSTANT CONNECTIONS
 ****************************************************************/

static NSString* CLIENT_ID = @"Unitienda";
static NSString* CLIENT_SECRET = @"Unitienda_Secret";
static NSInteger CONNECTION_TYPE_APACHE =0;
static NSInteger CONNECTION_TYPE_TOMCAT =1;
static NSString* GRANT_TYPE_USER_CREDENTIAL =@"password";
static NSString* GRANT_TYPE_USER_REFRESH_TOKEN =@"refresh_token";


+(NSString *) GET_CLIENT_ID{
    return CLIENT_ID;
}

+(NSString *) GET_CLIENT_SECRET{
    return CLIENT_SECRET;
}

+(NSInteger) GET_CONNECTION_TYPE_APACHE{
    return CONNECTION_TYPE_APACHE;
}

+(NSInteger) GET_CONNECTION_TYPE_TOMCAT{
    return CONNECTION_TYPE_TOMCAT;
}

+(NSString*) GET_GRANT_TYPE_USER_CREDENTIALS{
    return GRANT_TYPE_USER_CREDENTIAL;
}

+(NSString*) GET_GRANT_TYPE_REFRESH_TOKEN{
    return GRANT_TYPE_USER_REFRESH_TOKEN;
}



/****************************************************************
 LOGIN CONSTANTS
 ****************************************************************/
static NSString* LABEL_NAME_ACCESS_TOKEN = @"access_token";
static NSString* LABEL_NAME_EXPIRES_IN = @"expires_in";
static NSString* LABEL_NAME_TOKEN_TYPE = @"token_type";
static NSString* LABEL_NAME_SCOPE = @"scope";
static NSString* LABEL_NAME_REFRESH_TOKEN = @"refresh_token";
static NSString* LABEL_NAME_LOGIN_RESPONSE = @"loginResponse";
static NSString* LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION = @"loginResponseNoticication";
static NSString* LABEL_NAME_ERROR_RESPONSE = @"errorResponse";
static NSString* LABEL_NAME_REFRESH_TOKEN_RESPONSE = @"refreshTokenResponse";
static NSString* LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATION = @"refreshTokenResponseNotification";
static NSString* LABEL_NAME_LOGOUT_RESPONSE = @"logoutResponse";
static NSString* LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION = @"logoutResponseNoticication";


+(NSString *) GET_LABEL_NAME_ACCESS_TOKEN{
    return LABEL_NAME_ACCESS_TOKEN;
}

+(NSString *) GET_LABEL_NAME_EXPIRES_IN{
    return LABEL_NAME_EXPIRES_IN;
}

+(NSString *) GET_LABEL_NAME_TOKEN_TYPE{
    return LABEL_NAME_TOKEN_TYPE;
}

+(NSString *) GET_LABEL_NAME_SCOPE{
    return LABEL_NAME_SCOPE;
}

+(NSString *) GET_LABEL_NAME_REFRESH_TOKEN{
    return LABEL_NAME_REFRESH_TOKEN;
}

+(NSString *) GET_LABEL_NAME_LOGIN_RESPONSE{
    return LABEL_NAME_LOGIN_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION{
    return LABEL_NAME_LOGIN_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE{
    return LABEL_NAME_REFRESH_TOKEN_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATOIN{
    return LABEL_NAME_REFRESH_TOKEN_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_NAME_LOGOUT_RESPONSE{
    return LABEL_NAME_LOGOUT_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION{
    return LABEL_NAME_LOGOUT_RESPONSE_NOTIFICATION;
}

/****************************************************************
 PROFILE CONSTANTS
 ****************************************************************/
static NSString* LABEL_NAME_PROFILE_RESPONSE = @"profileResponse";
static NSString* LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION = @"profileResponseNoticication";
static NSString* LABEL_NAME_PROFILE_CREATOR_RESPONSE = @"profileCreatorResponse";
static NSString* LABEL_NAME_PROFILE_STORE_RESPONSE = @"profileCheckerResponse";
static NSString* LABEL_NAME_PROFILE_CREATOR_RESPONSE_NOTIFICATION = @"profileCreatorResponseNoticication";
static NSString* LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION = @"profileCheckerResponseNoticication";
static NSString* LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE = @"profileChangePasswordResponse";
static NSString* LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION = @"profileChangePasswordResponseNoticication";
static NSString* LABEL_USER_NAME = @"username";
static NSString* LABEL_FIRST_NAME = @"first_name";
static NSString* LABEL_LAST_NAME = @"last_name";
static NSString* LABEL_STORE_ID = @"store_id";
static NSString* LABEL_STORE_NAME = @"store_name";
static NSString* ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE = @"The access token provided has expired";
static NSString* ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE = @"invalid_grant";
static NSString* ERROR_FOUND_STORE_BY_ID = @"Non store found with the key :";

+(NSString *) GET_LABEL_NAME_PROFILE_RESPONSE{
    return LABEL_NAME_PROFILE_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION{
    return LABEL_NAME_PROFILE_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_NAME_PROFILE_CREATOR_RESPONSE{
    return LABEL_NAME_PROFILE_CREATOR_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_PROFILE_STORE_RESPONSE{
    return LABEL_NAME_PROFILE_STORE_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_PROFILE_CREATOR_RESPONSE_NOTIFICATION{
    return LABEL_NAME_PROFILE_CREATOR_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION{
    return LABEL_NAME_PROFILE_STORE_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE{
    return LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION{
    return LABEL_NAME_PROFILE_CHANGE_PASSWORD_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_STORE_NAME{
    return LABEL_STORE_NAME;
}

+(NSString *) GET_LABEL_STORE_ID{
    return LABEL_STORE_ID;
}

+(NSString *) GET_LABEL_USER_NAME{
    return LABEL_USER_NAME;
}

+(NSString *) GET_LABEL_FIRST_NAME{
    return LABEL_FIRST_NAME;
}

+(NSString *) GET_LABEL_LAST_NAME{
    return LABEL_LAST_NAME;
}

+(NSString *) GET_ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE{
    return ERROR_DESCRIPTION_EXPIRED_TOKEN_VALUE;
}

+(NSString *) GET_ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE{
    return ERROR_DESCRIPTION_EXPIRED_REFRESH_TOKEN_VALUE;
}

+(NSString *) GET_ERROR_FOUND_STORE_BY_ID{
    return ERROR_FOUND_STORE_BY_ID;
}

/****************************************************************
 PROMOTION CONSTANTS
 ****************************************************************/
static NSString* LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION = @"promotionByStoreWsResponseNotification";
static NSString* LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE = @"promotionByStoreWsResponse";

static NSString* LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE_NOTIFICATION = @"promotionByStorePersistenceResponseNotification";
static NSString* LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE = @"promotionByStorePersistenceResponse";


+(NSString *) GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION{
    return LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE{
    return LABEL_NAME_PROMOTION_BY_STORE_WS_RESPONSE;
}

+(NSString *) GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE_NOTIFICATION{
    return LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE_NOTIFICATION;
}

+(NSString *) GET_LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE{
    return LABEL_NAME_PROMOTION_BY_STORE_DATASYNC_RESPONSE;
}



/****************************************************************
 CONSTANT DICTIONARY
 ****************************************************************/
+(NSArray*) GET_NUMBER_STORES{
    return  @[@"Seleccione local",
              @"1-101",@"1-102",@"1-103",
              @"1-104",@"1-105",@"1-106",
              @"1-107",@"1-108",@"1-109",
              @"1-110",@"1-111",@"1-112",
              @"1-113",@"1-114",@"1-115",
              @"1-116",@"1-117",@"1-118",
              @"1-119",@"1-120",@"1-121",
              @"1-122",@"1-123",@"1-124",
              @"1-125",@"1-126",@"1-127",
              @"1-128",@"1-129",@"1-130",
              @"1-131",@"1-132",@"1-133",
              @"1-134",@"1-135",@"1-136",
              @"1-137",@"1-138",@"1-139",
              @"1-140",@"1-141",@"1-142",
              @"1-143",@"1-144",@"1-145",
              @"1-146",@"1-147",@"1-148",
              @"1-149",@"1-150",@"1-151",
              @"1-152",@"1-153",@"1-154",
              @"1-155",@"1-156",@"1-157",
              @"1-158",@"1-159",@"1-160",
              @"1-161",@"1-162",@"1-163",
              @"1-164",@"1-165",@"1-166",
              @"1-167",@"1-168",@"1-169",
              @"1-170",@"1-171",@"1-172",
              @"1-173",@"1-174",@"1-175",
              @"1-176",@"1-177",@"1-178",
              @"1-179",@"1-180",@"1-181",
              @"1-182",@"1-183",@"1-184",
              @"1-185",@"1-186",@"1-187",
              @"1-188",@"1-189",@"1-190",
              @"1-191",@"1-192",@"1-193",
              @"1-194",@"1-195",@"1-196",
              @"1-197", @"1-198", @"1-199",
              @"1-200"
              ];
}

+(NSDictionary*) GET_POSITION_DICTIONARY_STORE_NUMBER_AS_KEY
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithCGPoint:CGPointMake(88.0f, 202.0f)],@"1-101",
            [NSValue valueWithCGPoint:CGPointMake(115.0f, 219.0f)],@"1-102",
            [NSValue valueWithCGPoint:CGPointMake(175.0f, 227.0f)],@"1-103",
            [NSValue valueWithCGPoint:CGPointMake(199.0f, 241.0f)],@"1-104",
            [NSValue valueWithCGPoint:CGPointMake(197.0f, 280.0f)],@"1-105",
            [NSValue valueWithCGPoint:CGPointMake(215.0f, 303.0f)],@"1-106",
            [NSValue valueWithCGPoint:CGPointMake(266.0f, 306.0f)],@"1-107",
            [NSValue valueWithCGPoint:CGPointMake(296.0f, 325.0f)],@"1-108",
            [NSValue valueWithCGPoint:CGPointMake(271.0f, 335.0f)],@"1-109",
            [NSValue valueWithCGPoint:CGPointMake(249.0f, 325.0f)],@"1-110",
            [NSValue valueWithCGPoint:CGPointMake(230.0f, 335.0f)],@"1-111",
            [NSValue valueWithCGPoint:CGPointMake(220.0f, 352.0f)],@"1-112",
            [NSValue valueWithCGPoint:CGPointMake(197.0, 374.0)],@"1-113",
            [NSValue valueWithCGPoint:CGPointMake(225.0, 417.0)],@"1-114",
            [NSValue valueWithCGPoint:CGPointMake(244.0, 425.0)],@"1-115",
            [NSValue valueWithCGPoint:CGPointMake(241.0, 393.0)],@"1-116",
            [NSValue valueWithCGPoint:CGPointMake(264.0, 391.0)],@"1-117",
            [NSValue valueWithCGPoint:CGPointMake(276.0, 383.0)],@"1-118",
            [NSValue valueWithCGPoint:CGPointMake(292.0, 374.0)],@"1-119",
            [NSValue valueWithCGPoint:CGPointMake(330.0, 417.0)],@"1-120",
            [NSValue valueWithCGPoint:CGPointMake(344.0, 372.0)],@"1-121",
            [NSValue valueWithCGPoint:CGPointMake(364.0, 386.0)],@"1-122",
            [NSValue valueWithCGPoint:CGPointMake(368.0, 392.0)],@"1-123",
            [NSValue valueWithCGPoint:CGPointMake(385.0, 399.0)],@"1-124",
            [NSValue valueWithCGPoint:CGPointMake(404.0, 421.0)],@"1-125",
            [NSValue valueWithCGPoint:CGPointMake(385.0, 431.0)],@"1-126",
            [NSValue valueWithCGPoint:CGPointMake(424.0, 390.0)],@"1-127",
            [NSValue valueWithCGPoint:CGPointMake(379.0, 327.0)],@"1-128",
            [NSValue valueWithCGPoint:CGPointMake(445.0, 365.0)],@"1-129",
            [NSValue valueWithCGPoint:CGPointMake(419.0, 369.0)],@"1-130",
            [NSValue valueWithCGPoint:CGPointMake(411.0, 351.0)],@"1-131",
            [NSValue valueWithCGPoint:CGPointMake(400.0, 342.0)],@"1-132",
            [NSValue valueWithCGPoint:CGPointMake(387.0, 327.0)],@"1-133",
            [NSValue valueWithCGPoint:CGPointMake(361.0, 334.0)],@"1-134",
            [NSValue valueWithCGPoint:CGPointMake(334.0, 329.0)],@"1-135",
            [NSValue valueWithCGPoint:CGPointMake(312.0, 299.0)],@"1-136",
            [NSValue valueWithCGPoint:CGPointMake(294.0, 291.0)],@"1-137",
            [NSValue valueWithCGPoint:CGPointMake(311.0, 279.0)],@"1-138",
            [NSValue valueWithCGPoint:CGPointMake(321.0, 217.0)],@"1-139",
            [NSValue valueWithCGPoint:CGPointMake(413.0, 300.0)],@"1-140",
            [NSValue valueWithCGPoint:CGPointMake(428.0, 278.0)],@"1-141",
            [NSValue valueWithCGPoint:CGPointMake(449.0, 253.0)],@"1-142",
            [NSValue valueWithCGPoint:CGPointMake(479.0, 233.0)],@"1-143",
            [NSValue valueWithCGPoint:CGPointMake(501.0, 225.0)],@"1-144",
            [NSValue valueWithCGPoint:CGPointMake(522.0, 202.0)],@"1-145",
            [NSValue valueWithCGPoint:CGPointMake(580.0, 237.0)],@"1-146",
            [NSValue valueWithCGPoint:CGPointMake(565.0, 268.0)],@"1-147",
            [NSValue valueWithCGPoint:CGPointMake(551.0, 276.0)],@"1-148",
            [NSValue valueWithCGPoint:CGPointMake(530.0, 300.0)],@"1-149",
            [NSValue valueWithCGPoint:CGPointMake(556.0, 306.0)],@"1-150",
            [NSValue valueWithCGPoint:CGPointMake(562.0, 318.0)],@"1-151",
            [NSValue valueWithCGPoint:CGPointMake(503.0, 341.0)],@"1-152",
            [NSValue valueWithCGPoint:CGPointMake(579.0, 338.0)],@"1-153",
            [NSValue valueWithCGPoint:CGPointMake(537.0, 490.0)],@"1-154",
            [NSValue valueWithCGPoint:CGPointMake(587.0, 347.0)],@"1-155",
            [NSValue valueWithCGPoint:CGPointMake(562.0, 368.0)],@"1-156",
            [NSValue valueWithCGPoint:CGPointMake(579.0, 393.0)],@"1-157",
            [NSValue valueWithCGPoint:CGPointMake(586.0, 409.0)],@"1-158",
            [NSValue valueWithCGPoint:CGPointMake(488.0, 424.0)],@"1-159",
            [NSValue valueWithCGPoint:CGPointMake(507.0, 459.0)],@"1-160",
            [NSValue valueWithCGPoint:CGPointMake(514.0, 473.0)],@"1-161",
            [NSValue valueWithCGPoint:CGPointMake(538.0, 486.0)],@"1-162",
            [NSValue valueWithCGPoint:CGPointMake(553.0, 508.0)],@"1-163",
            [NSValue valueWithCGPoint:CGPointMake(565.0, 515.0)],@"1-164",
            [NSValue valueWithCGPoint:CGPointMake(573.0, 531.0)],@"1-165",
            [NSValue valueWithCGPoint:CGPointMake(581.0, 553.0)],@"1-166",
            [NSValue valueWithCGPoint:CGPointMake(476.0, 494.0)],@"1-167",
            [NSValue valueWithCGPoint:CGPointMake(442.0, 552.0)],@"1-168",
            [NSValue valueWithCGPoint:CGPointMake(423.0, 546.0)],@"1-169",
            [NSValue valueWithCGPoint:CGPointMake(403.0, 578.0)],@"1-170",
            [NSValue valueWithCGPoint:CGPointMake(385.0, 597.0)],@"1-171",
            [NSValue valueWithCGPoint:CGPointMake(354.0, 624.0)],@"1-172",
            [NSValue valueWithCGPoint:CGPointMake(310.0, 517.0)],@"1-173",
            [NSValue valueWithCGPoint:CGPointMake(271.0, 624.0)],@"1-174",
            [NSValue valueWithCGPoint:CGPointMake(259.0, 587.0)],@"1-175",
            [NSValue valueWithCGPoint:CGPointMake(209.0, 656.0)],@"1-176",
            [NSValue valueWithCGPoint:CGPointMake(183.0, 631.0)],@"1-177",
            [NSValue valueWithCGPoint:CGPointMake(165.0, 609.0)],@"1-178",
            [NSValue valueWithCGPoint:CGPointMake(152.0, 623.0)],@"1-179",
            [NSValue valueWithCGPoint:CGPointMake(193.0, 556.0)],@"1-180",
            [NSValue valueWithCGPoint:CGPointMake(166.0, 518.0)],@"1-181",
            [NSValue valueWithCGPoint:CGPointMake(122.0, 454.0)],@"1-182",
            [NSValue valueWithCGPoint:CGPointMake(108.0, 463.0)],@"1-183",
            [NSValue valueWithCGPoint:CGPointMake(90.0, 482.0)],@"1-184",
            [NSValue valueWithCGPoint:CGPointMake(71.0, 494.0)],@"1-185",
            [NSValue valueWithCGPoint:CGPointMake(66.0, 521.0)],@"1-186",
            [NSValue valueWithCGPoint:CGPointMake(53.0, 527.0)],@"1-187",
            [NSValue valueWithCGPoint:CGPointMake(42.0, 531.0)],@"1-188",
            [NSValue valueWithCGPoint:CGPointMake(13.0, 542.0)],@"1-189",
            [NSValue valueWithCGPoint:CGPointMake(30.0, 557.0)],@"1-190",
            [NSValue valueWithCGPoint:CGPointMake(48.0, 572.0)],@"1-191",
            [NSValue valueWithCGPoint:CGPointMake(87.0, 602.0)],@"1-192",
            [NSValue valueWithCGPoint:CGPointMake(20.0, 437.0)],@"1-193",
            [NSValue valueWithCGPoint:CGPointMake(61.0, 352.0)],@"1-194",
            [NSValue valueWithCGPoint:CGPointMake(138.0, 343.0)],@"1-195",
            [NSValue valueWithCGPoint:CGPointMake(69.0, 317.0)],@"1-196",
            [NSValue valueWithCGPoint:CGPointMake(79.0f, 303.0f)],@"1-197",
            [NSValue valueWithCGPoint:CGPointMake(100.0f, 293.0f)],@"1-198",
            [NSValue valueWithCGPoint:CGPointMake(83.0f, 270.0f)],@"1-199",
            [NSValue valueWithCGPoint:CGPointMake(69.0f, 266.0f)],@"1-200",
            [NSValue valueWithCGPoint:CGPointMake(51.0f, 244.0f)],@"1-201",
            [NSValue valueWithCGPoint:CGPointMake(31.0f, 275.0f)],@"1-202",
            [NSValue valueWithCGPoint:CGPointMake(17.0f, 261.0f)],@"1-203",
            [NSValue valueWithCGPoint:CGPointMake(24.0f, 241.0f)],@"1-204",
            nil];
}

+(NSDictionary*) GET_POSITION_DICTIONARY_ORIGIN_LAYER_AS_KEY{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"1-101",[NSValue valueWithCGPoint:CGPointMake(64.0f, 167.0f)],
            @"1-102",[NSValue valueWithCGPoint:CGPointMake(88.0f, 202.0f)],
            @"1-103",[NSValue valueWithCGPoint:CGPointMake(99.0f, 202.0f)],
            @"1-104",[NSValue valueWithCGPoint:CGPointMake(134.0f, 220.0f)],
            @"1-105",[NSValue valueWithCGPoint:CGPointMake(157.0f, 242.0f)],
            @"1-106",[NSValue valueWithCGPoint:CGPointMake(178.0f, 265.0f)],
            @"1-107",[NSValue valueWithCGPoint:CGPointMake(242.0f, 289.0f)],
            @"1-108",[NSValue valueWithCGPoint:CGPointMake(269.0f, 310.0f)],
            @"1-109",[NSValue valueWithCGPoint:CGPointMake(259.0f, 327.0f)],
            @"1-110",[NSValue valueWithCGPoint:CGPointMake(226.0f, 311.0f)],
            @"1-111",[NSValue valueWithCGPoint:CGPointMake(213.0f, 327.0f)],
            @"1-112",[NSValue valueWithCGPoint:CGPointMake(203.0f, 338.0f)],
            @"1-113",[NSValue valueWithCGPoint:CGPointMake(171.0f, 348.0f)],
            @"1-114",[NSValue valueWithCGPoint:CGPointMake(103.0f, 333.0f)],
            @"1-115",[NSValue valueWithCGPoint:CGPointMake(56.0f, 282.0f)],
            @"1-116",[NSValue valueWithCGPoint:CGPointMake(41.0f, 295.0f)],
            @"1-117",[NSValue valueWithCGPoint:CGPointMake(43.0f, 251.0f)],
            @"1-118",[NSValue valueWithCGPoint:CGPointMake(21.0f, 229.0f)],
            @"1-119",[NSValue valueWithCGPoint:CGPointMake(17.0f, 268.0f)],
            @"1-120",[NSValue valueWithCGPoint:CGPointMake(13.0f, 239.0f)],
            @"1-121",[NSValue valueWithCGPoint:CGPointMake(3.0f, 251.0f)],
            @"1-122",[NSValue valueWithCGPoint:CGPointMake(3.0f, 304.0f)],
            @"1-123",[NSValue valueWithCGPoint:CGPointMake(0.0f, 414.0f)],
            @"1-124",[NSValue valueWithCGPoint:CGPointMake(104.0f, 409.0f)],
            @"1-125",[NSValue valueWithCGPoint:CGPointMake(94.0f, 434.0f)],
            @"1-126",[NSValue valueWithCGPoint:CGPointMake(82.0f, 447.0f)],
            @"1-127",[NSValue valueWithCGPoint:CGPointMake(60.0f, 457.0f)],
            @"1-128",[NSValue valueWithCGPoint:CGPointMake(49.0f, 480.0f)],
            @"1-129",[NSValue valueWithCGPoint:CGPointMake(37.0f, 491.0f)],
            @"1-130",[NSValue valueWithCGPoint:CGPointMake(26.0f, 501.0f)],
            @"1-131",[NSValue valueWithCGPoint:CGPointMake(15.0f, 514.0f)],
            @"1-132",[NSValue valueWithCGPoint:CGPointMake(1.0f, 536.0f)],
            @"1-133",[NSValue valueWithCGPoint:CGPointMake(8.0f, 548.0f)],
            @"1-134",[NSValue valueWithCGPoint:CGPointMake(19.0f, 559.0f)],
            @"1-135",[NSValue valueWithCGPoint:CGPointMake(43.0f, 544.0f)],
            @"1-136",[NSValue valueWithCGPoint:CGPointMake(142.0f, 618.0f)],
            @"1-137",[NSValue valueWithCGPoint:CGPointMake(153.0f, 606.0f)],
            @"1-138",[NSValue valueWithCGPoint:CGPointMake(168.0f, 623.0f)],
            @"1-139",[NSValue valueWithCGPoint:CGPointMake(193.0f, 649.0f)],
            @"1-140",[NSValue valueWithCGPoint:CGPointMake(150.0f, 501.0f)],
            @"1-141",[NSValue valueWithCGPoint:CGPointMake(178.0f, 534.0f)],
            @"1-142",[NSValue valueWithCGPoint:CGPointMake(196.0f, 554.0f)],
            @"1-143",[NSValue valueWithCGPoint:CGPointMake(226.0f, 594.0f)],
            @"1-144",[NSValue valueWithCGPoint:CGPointMake(298.0f, 504.0f)],
            @"1-145",[NSValue valueWithCGPoint:CGPointMake(335.0f, 594.0f)],
            @"1-146",[NSValue valueWithCGPoint:CGPointMake(359.0f, 534.0f)],
            @"1-147",[NSValue valueWithCGPoint:CGPointMake(376.0f, 501.0f)],
            @"1-148",[NSValue valueWithCGPoint:CGPointMake(401.0f, 480.0f)],
            @"1-149",[NSValue valueWithCGPoint:CGPointMake(421.0f, 457.0f)],
            @"1-150",[NSValue valueWithCGPoint:CGPointMake(450.0f, 403.0f)],
            @"1-151",[NSValue valueWithCGPoint:CGPointMake(481.0f, 434.0f)],
            @"1-152",[NSValue valueWithCGPoint:CGPointMake(492.0f, 447.0f)],
            @"1-153",[NSValue valueWithCGPoint:CGPointMake(503.0f, 457.0f)],
            @"1-154",[NSValue valueWithCGPoint:CGPointMake(526.0f, 480.0f)],
            @"1-155",[NSValue valueWithCGPoint:CGPointMake(537.0f, 490.0f)],
            @"1-156",[NSValue valueWithCGPoint:CGPointMake(549.0f, 501.0f)],
            @"1-157",[NSValue valueWithCGPoint:CGPointMake(561.0f, 524.0f)],
            @"1-158",[NSValue valueWithCGPoint:CGPointMake(571.0f, 390.0f)],
            @"1-159",[NSValue valueWithCGPoint:CGPointMake(559.0f, 368.0f)],
            @"1-160",[NSValue valueWithCGPoint:CGPointMake(535.0f, 343.0f)],
            @"1-161",[NSValue valueWithCGPoint:CGPointMake(579.0f, 336.0f)],
            @"1-162",[NSValue valueWithCGPoint:CGPointMake(571.0f, 330.0f)],
            @"1-163",[NSValue valueWithCGPoint:CGPointMake(541.0f, 289.0f)],
            @"1-164",[NSValue valueWithCGPoint:CGPointMake(469.0f, 333.0f)],
            @"1-165",[NSValue valueWithCGPoint:CGPointMake(528.0f, 282.0f)],
            @"1-166",[NSValue valueWithCGPoint:CGPointMake(511.0f, 274.0f)],
            @"1-167",[NSValue valueWithCGPoint:CGPointMake(546.0f, 251.0f)],
            @"1-168",[NSValue valueWithCGPoint:CGPointMake(559.0f, 227.0f)],
            @"1-169",[NSValue valueWithCGPoint:CGPointMake(481.0f, 167.0f)],
            @"1-170",[NSValue valueWithCGPoint:CGPointMake(457.0f, 195.0f)],
            @"1-171",[NSValue valueWithCGPoint:CGPointMake(435.0f, 195.0f)],
            @"1-172",[NSValue valueWithCGPoint:CGPointMake(412.0f, 220.0f)],
            @"1-173",[NSValue valueWithCGPoint:CGPointMake(390.0f, 242.0f)],
            @"1-174",[NSValue valueWithCGPoint:CGPointMake(371.0f, 265.0f)],
            @"1-175",[NSValue valueWithCGPoint:CGPointMake(419.0f, 348.0f)],
            @"1-176",[NSValue valueWithCGPoint:CGPointMake(414.0f, 374.0f)],
            @"1-177",[NSValue valueWithCGPoint:CGPointMake(401.0f, 361.0f)],
            @"1-178",[NSValue valueWithCGPoint:CGPointMake(390.0f, 339.0f)],
            @"1-179",[NSValue valueWithCGPoint:CGPointMake(379.0f, 327.0f)],
            @"1-180",[NSValue valueWithCGPoint:CGPointMake(365.0f, 311.0f)],
            @"1-181",[NSValue valueWithCGPoint:CGPointMake(345.0f, 289.0f)],
            @"1-182",[NSValue valueWithCGPoint:CGPointMake(345.0f, 327.0f)],
            @"1-183",[NSValue valueWithCGPoint:CGPointMake(318.0f, 311.0f)],
            @"1-184",[NSValue valueWithCGPoint:CGPointMake(326.0f, 366.0f)],
            @"1-185",[NSValue valueWithCGPoint:CGPointMake(340.0f, 368.0f)],
            @"1-186",[NSValue valueWithCGPoint:CGPointMake(347.0f, 379.0f)],
            @"1-187",[NSValue valueWithCGPoint:CGPointMake(373.0f, 393.0f)],
            @"1-188",[NSValue valueWithCGPoint:CGPointMake(380.0f, 401.0f)],
            @"1-189",[NSValue valueWithCGPoint:CGPointMake(359.0f, 407.0f)],
            @"1-190",[NSValue valueWithCGPoint:CGPointMake(242.0f, 365.0f)],
            @"1-191",[NSValue valueWithCGPoint:CGPointMake(228.0f, 406.0f)],
            @"1-192",[NSValue valueWithCGPoint:CGPointMake(213.0f, 401.0f)],
            @"1-193",[NSValue valueWithCGPoint:CGPointMake(231.0f, 390.0f)],
            @"1-194",[NSValue valueWithCGPoint:CGPointMake(242.0f, 379.0f)],
            @"1-195",[NSValue valueWithCGPoint:CGPointMake(259.0f, 368.0f)],
            @"1-196",[NSValue valueWithCGPoint:CGPointMake(276.0f, 366.0f)],
            @"1-197",[NSValue valueWithCGPoint:CGPointMake(293.0f, 282.0f)],
            @"1-198",[NSValue valueWithCGPoint:CGPointMake(281.0f, 284.0f)],
            @"1-199",[NSValue valueWithCGPoint:CGPointMake(297.0f, 270.0f)],
            @"1-200",[NSValue valueWithCGPoint:CGPointMake(233.0f, 189.0f)],
            nil];

}

@end
