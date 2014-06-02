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
#import "TestViewController.h"
#import "TestTwoViewController.h"

@interface RootPageViewController () <UIPageViewControllerDataSource>
@property MainTableViewController *mainTableViewController;
@property FavoritesTableViewController *favoritesTableViewController;
@property TestViewController *testViewController;
@property TestTwoViewController *testTwoViewController;
@end

@implementation RootPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = self;
    [self setupScene];
//    [self setupNavScene];
    [self setupPageControl];
}

//- (void)setupNavScene
//{
//    UINavigationController *navM = [self.storyboard instantiateViewControllerWithIdentifier:@"navM"];
//    UINavigationController *navF = [self.storyboard instantiateViewControllerWithIdentifier:@"navF"];
//
//    [self setViewControllers:@[navM]
//                   direction:UIPageViewControllerNavigationDirectionForward
//                    animated:NO
//                  completion:nil];
//
//    [self addChildViewController:navF];
//    NSLog(@"%@",self.childViewControllers);
//}

- (void)setupScene
{
//    self.mainTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTableViewController"];
//    self.FavoritesTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesTableViewController"];


    self.testViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
    self.testTwoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestTwoViewController"];

    [self setViewControllers:@[self.testViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];

    [self addChildViewController:self.testTwoViewController];
}

- (void)setupPageControl
{
//    UIPageControl *pageControl = [UIPageControl appearance];
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//    pageControl.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Page View Controller Data Source

//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}
//
//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 2;
//}


//-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
//     viewControllerBeforeViewController:(UIViewController *)viewController
//{
//    if ([viewController isKindOfClass:[FavoritesTableViewController class]])
//    {
//        return self.childViewControllers[0];
//    }
//    else
//    {
//        return nil;
//    }
//}
//
//-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
//      viewControllerAfterViewController:(UIViewController *)viewController
//{
//    if ([viewController isKindOfClass:[MainTableViewController class]])
//    {
//        return self.childViewControllers[1];
//    }
//    else
//    {
//        return nil;
//    }
//}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[TestTwoViewController class]])
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
    if ([viewController isKindOfClass:[TestViewController class]])
    {
        return self.childViewControllers[1];
    }
    else
    {
        return nil;
    }
}

@end