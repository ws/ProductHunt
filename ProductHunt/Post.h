//
//  Post.h
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
@property NSString *productLink;
@property NSString *title;
@property NSString *subtitle;
@property NSString *imageLink;
@property NSString *commentLink;
@property BOOL saved;

- (Post *)initWithproductLink:(NSString *)productLink
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle
                    imageLink:(NSString *)imageLink
                  commentLink:(NSString *)commentLink;

@end
