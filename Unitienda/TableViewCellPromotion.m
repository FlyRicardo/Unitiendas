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
            NSURL * imageURL = [NSURL URLWithString:photo.url];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
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

@end
