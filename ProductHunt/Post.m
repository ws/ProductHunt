//
//  Post.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "Post.h"

#define kProductLink @"productLink"
#define kTitle @"title"
#define kSubtitle @"subtitle"
#define kImageLink @"imageLink"
#define kCommentLink @"commentLink"
#define kSaved @"saved"


@implementation Post

- (Post *)initWithproductLink:(NSString *)productLink
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle
                    imageLink:(NSString *)imageLink
                  commentLink:(NSString *)commentLink;
{
    self.productLink = productLink;
    self.title = title;
    self.subtitle = subtitle;
    self.imageLink = imageLink;
    self.commentLink = commentLink;
    self.saved = NO;
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.productLink forKey:kProductLink];
    [coder encodeObject:self.title forKey:kTitle];
    [coder encodeObject:self.subtitle forKey:kSubtitle];
    [coder encodeObject:self.imageLink forKey:kImageLink];
    [coder encodeObject:self.commentLink forKey:kCommentLink];
    [coder encodeObject:[NSNumber numberWithBool:self.saved] forKey:kSaved];
}
-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    self.productLink = [decoder decodeObjectForKey:kProductLink];
    self.title = [decoder decodeObjectForKey:kTitle];
    self.subtitle = [decoder decodeObjectForKey:kSubtitle];
    self.imageLink = [decoder decodeObjectForKey:kImageLink];
    self.commentLink = [decoder decodeObjectForKey:kCommentLink];
    self.saved = [[decoder decodeObjectForKey:kSaved] boolValue];

    return  self;
}

@end
