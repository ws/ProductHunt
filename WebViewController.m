//
//  WebViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.post.title;

    NSURL *url = [NSURL URLWithString:self.post.productLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}

- (IBAction)onRefreshButtonPressed:(id)sender
{
    [self.webView reload];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        if (self.navigationController.navigationBarHidden)
        {
            self.navigationController.navigationBarHidden = NO;
        }
        else
        {
            self.navigationController.navigationBarHidden = YES;
        }
    }
}

@end
