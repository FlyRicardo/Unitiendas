//
//  WSArticleConnector.h
//  Unitienda
//
//  Created by Fly on 9/8/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WSPromotionConnector.h"

#import "Article.h"

@protocol WSArticleConnector

-(void) createArticle:(Article*) article;       //Notify to its selector the status of createArticle Web service
                                                    //Params: Success NSArray {@Meta class}
                                                    //        Failure @Meta class

-(void) editArticle:(Article*) article;         //Notify to its selector the status of editArticle Web service
                                                    //Params: Success NSArray {@Meta class}
                                                    //        Failure @Meta class

@end