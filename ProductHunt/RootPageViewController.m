//
//  RootPageViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 6/2/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "RootPageViewController.h"
#import "TableViewController.h"
#import "FavoritesTableViewController.h"

@interface RootPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property TableViewController *tableViewController;
@property FavoritesTableViewController *favoritesTableViewController;
@property int currentIndex;
@end

@implementation RootPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;

    self.title = @"Product Hunt";

    [self setupScene];
    [self setupPageControl];
}

- (void)setupScene
{
    self.tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTableViewController"];
    self.favoritesTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesTableViewController"];

    self.tableViewController.index = 0;
    self.favoritesTableViewController.index = 1;

    [self setViewControllers:@[self.tableViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];

    [self addChildViewController:self.favoritesTableViewController];

    self.currentIndex = 0;
}

- (void)setupPageControl
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
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
    if ([viewController isKindOfClass:[TableViewController class]])
    {
        return self.childViewControllers[1];
    }
    else
    {
        return nil;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        if ([previousViewControllers.firstObject isKindOfClass:[FavoritesTableViewController class]])
        {
            self.title = @"Product Hunt";
        }
        else if ([previousViewControllers.firstObject isKindOfClass:[TableViewController class]])
        {
            self.title = @"Favorites";
        }
    }
}

@end