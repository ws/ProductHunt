//
//  RootViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "RootPageViewController.h"
#import "MainTableViewController.h"
#import "FavoritesTableViewController.h"

@interface RootPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property MainTableViewController *mainTableViewController;
@property FavoritesTableViewController *favoritesTableViewController;
@end

@implementation RootPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Product Hunt";
    self.dataSource = self;
    self.delegate = self;
    [self setupScene];
    [self setupPageControl];
}

- (void)setupScene
{
    self.mainTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTableViewController"];
    self.FavoritesTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesTableViewController"];

    [self setViewControllers:@[self.mainTableViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];

    [self addChildViewController:self.favoritesTableViewController];
}

- (void)setupPageControl
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];


//    self.navigationItem.titleView = [[]];
}

#pragma mark - Page View Controller Data Source

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[FavoritesTableViewController class]])
    {
        self.title = @"Product Hunt";
        return self.childViewControllers[0];
    }
    else
    {
        return nil;
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[MainTableViewController class]])
    {
        return self.childViewControllers[1];
    }
    else
    {
        return nil;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if ([previousViewControllers[0] isKindOfClass:[FavoritesTableViewController class]])
    {
        self.title = @"Product Hunt";
    }
    else
    {
        self.title = @"Favorites";
    }
}

@end