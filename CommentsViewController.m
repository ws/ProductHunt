//
//  CommentsViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:self.post.commentLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        [self.webView reload];
    }
}

@end
