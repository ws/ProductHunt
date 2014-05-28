//
//  WebViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "WebViewController.h"
#import "NJKScrollFullscreen.h"                                                                                 //NJKFullScreen
#import "UIViewController+NJKFullScreenSupport.h"                                                               //NJKFullScreen

@interface WebViewController () <UIWebViewDelegate, UIScrollViewDelegate, NJKScrollFullscreenDelegate>          //NJKFullScreen (last 2)
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property NJKScrollFullScreen *scrollProxy;                                                                     //NJKFullScreen
@property BOOL hideNavBarOnScroll;                                                                              //NJKFullScreen
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

    self.hideNavBarOnScroll = true;                                                                             //NJKFullScreen
    if (self.hideNavBarOnScroll)                                                                                //NJKFullScreen
    {                                                                                                           //NJKFullScreen
        _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];                                //NJKFullScreen
        self.webView.scrollView.delegate = (id)_scrollProxy;                                                    //NJKFullScreen
        _scrollProxy.delegate = self;                                                                           //NJKFullScreen
    }                                                                                                           //NJKFullScreen
}

#pragma mark -
#pragma mark NJKFullScreen Pod Delegate Methods

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigtionBar:deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
}

#pragma mark -

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

- (IBAction)share:(id)sender
{
    NSString *title = self.post.title;
    NSString *subtitle = self.post.subtitle;
    NSString *text = [[title stringByAppendingString:@" - "] stringByAppendingString:subtitle];
    NSURL *url = [NSURL URLWithString:self.post.commentLink];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.post.imageLink]]];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url]
                                                                             applicationActivities:nil];

    controller.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo];

    [self presentViewController:controller animated:YES completion:nil];
}

@end