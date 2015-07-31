//
//  TableViewCellPromotion.m
//  Unitienda
//
//  Created by Fly on 6/18/15.
//  Copyright (c) 2015 ___FlyInc___. All rights reserved.
//

#import "TableViewCellPromotion.h"
#import "Article.h"
#import "Photo.h"
#import "Promotion.h"
#import "CacheManager.h"
#import "ReachabilityImpl.h"
#import "ImageHandler.h"

@implementation TableViewCellPromotion

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setCacheImage:(NSSet*)photos{
    __block Photo* photo;
    [photos enumerateObjectsUsingBlock:^(id obj, BOOL *stop) { // This block is the advised way to iterate over a Set (structure that doesn't has iterators)
        photo = (Photo*)obj;
        if([[photo type] isEqualToString:@"PEQ"]){
            *stop = YES;
        }
    }];
    
    UIImage *cached_image = [[CacheManager sharedCacheController] getCachedImage:[NSString stringWithFormat:@"image-%@",[photo url]]];
    
    if(cached_image != nil){
        [_rowArticleImageView setImage:cached_image];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            UIImage *image;
            NSString* extension =[[ImageHandler getInstance] getExtensionFromURL:[photo url]];
            NSString* fileName =[[ImageHandler getInstance] getImageNameFromURL:[photo url]];

            if(![[ReachabilityImpl getInstance] hostIsReachable2]){
                image = [[ImageHandler getInstance] loadImage:fileName ofType:extension];
            }else{
                NSURL * imageURL = [NSURL URLWithString:photo.url];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
                
                if([[ImageHandler getInstance] loadImage:fileName ofType:extension] == nil){
                    //If the image doesnt exist locally, save it from ws
                    [[ImageHandler getInstance] saveImageLocallyWithFileName:fileName ofType:extension AndURL:[photo url]];
                }
                image = [UIImage imageWithData:imageData];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_rowArticleImageView setImage: image];
                [[CacheManager sharedCacheController] setCachedImage:image name:[NSString stringWithFormat:@"image-%@", [photo url]]];
            });
        });
    }
}

-(void) setPromotionParameter:(Promotion *)promotion articlePhotos:(NSSet*) photos{
    [self setCacheImage:photos];
}

-(void) setArticle:(Article *)article{
    [[self rowArticleNameLabel] setText:[article name]];
    [self setCacheImage:[article photo]];
}

-(void) setPromotion:(Promotion *)promotion{
    [[self rowPercentageEffectivenessLabel] setText:[NSString stringWithFormat:@"%@%% porcein de efectividad",[[promotion effectiveness] stringValue]]];
    [[self rowDueDateLabel] setText:[self customFormatDate:[promotion dueDate]]];
}

-(NSString*) customFormatDate:(NSDate*) date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat stringFromDate:date];
}

@end
