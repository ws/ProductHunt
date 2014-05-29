//
//  CommentsViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "CommentsViewController.h"
#import "NJKScrollFullscreen.h"                                                                                 //NJKFullScreen
#import "UIViewController+NJKFullScreenSupport.h"                                                               //NJKFullScreen
#import "SuProgress.h"                                                                                          //SuProgress

@interface CommentsViewController () <UIWebViewDelegate, UIScrollViewDelegate, NJKScrollFullscreenDelegate>          //NJKFullScreen (last 2)
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property NSURL *url;
@property NJKScrollFullScreen *scrollProxy;                                                                     //NJKFullScreen
@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self SuProgressForWebView:self.webView];                                                                   //SuProgress
    self.backButton.enabled = NO;

    if (self.loadingComments)
    {
        //Title set in storyboard
        self.url = [NSURL URLWithString:self.post.commentLink];
    }
    else
    {
        self.title = self.post.title;
        self.url = [NSURL URLWithString:self.post.productLink];
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;

    if (YES)                                                                                                    //NJKFullScreen
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
#pragma mark WebView Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if ([self.webView canGoBack])
    {
        self.backButton.enabled = YES;
    }
    else
    {
        self.backButton.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.webView stopLoading];
}

#pragma mark -
#pragma mark BackButton / Reload on Shake

- (IBAction)onBackPress:(id)sender
{
    [self.webView goBack];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        [self.webView reload];
    }
}

#pragma mark -
#pragma mark Share

//- (IBAction)share:(id)sender
//{
//    NSString *title = self.post.title;
//    NSString *subtitle = self.post.subtitle;
//    NSString *text = [@"Check out: " stringByAppendingString:[[title stringByAppendingString:@" - "] stringByAppendingString:subtitle]];
//    NSURL *url = [NSURL URLWithString:self.post.productLink];
//    //    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.post.imageLink]]];
//
//    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url]
//                                                                             applicationActivities:nil];
//
//    controller.excludedActivityTypes = @[UIActivityTypeAssignToContact,
//                                         UIActivityTypeSaveToCameraRoll,
//                                         UIActivityTypePostToFlickr,
//                                         UIActivityTypePostToVimeo];
//
//    [self presentViewController:controller animated:YES completion:nil];
//}

@end
