//
//  WebViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/20/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "WebViewController.h"
#import "CommentsViewController.h"
#import "SuProgress.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.post.title;


    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                  target:self
                                                                                  action:@selector(share)];

    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                target:self
                                                                                action:@selector(comment)];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareButton, composeButton, nil];

//    NSURL *url = [NSURL URLWithString:self.post.productLink];
    NSURL *url = [NSURL URLWithString:self.post.commentLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}

#pragma mark - WebView Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityView stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityView stopAnimating];
    NSLog(@"Error: %@", error);
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        [self.webView reload];
    }
}

#pragma mark - Web Load View Change Handling

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [self SuProgressForWebView:self.webView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.webView stopLoading];
    self.webView.delegate = nil;

//    [self SuProgressForWebView:nil];
}

#pragma mark - Share

- (void)share
{
    NSString *title = self.post.title;
    NSString *subtitle = self.post.subtitle;
    NSString *text = [@"Check out: " stringByAppendingString:[[title stringByAppendingString:@" - "] stringByAppendingString:subtitle]];
    NSURL *url = [NSURL URLWithString:self.post.productLink];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url]
                                                                             applicationActivities:nil];

    controller.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)comment
{
    [self performSegueWithIdentifier:@"WebToCommentModal" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    CommentsViewController *commentsViewController = [navigationController.viewControllers objectAtIndex:0];
    commentsViewController.post = self.post;
}

@end