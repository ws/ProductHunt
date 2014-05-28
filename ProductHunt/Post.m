//
//  Post.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "Post.h"

@implementation Post

- (Post *)initWithproductLink:(NSString *)productLink title:(NSString *)title subtitle:(NSString *)subtitle imageLink:(NSString *)imageLink commentLink:(NSString *)commentLink;
{
    self.productLink = productLink;
    self.title = title;
    self.subtitle = subtitle;
    self.imageLink = imageLink;
    self.commentLink = commentLink;
    self.saved = NO;
    return self;
}

@end
