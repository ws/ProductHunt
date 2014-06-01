//
//  CommentsViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "CommentsViewController.h"
#import "SuProgress.h"

@interface CommentsViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self SuProgressForWebView:self.webView];

    self.backButton.enabled = NO;
    NSURL *url = [NSURL URLWithString:self.post.commentLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}

#pragma mark -
#pragma mark WebView Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if ([self.webView canGoBack])
    {
        self.backButton.enabled = YES;
    }
    else
    {
        self.backButton.enabled = NO;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark Kill Web Load on View Change

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self SuProgressForWebView:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -

- (IBAction)onBackPress:(id)sender
{
    [self.webView goBack];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
//        [self.webView reload];
    }
}

@end
