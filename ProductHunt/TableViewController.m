//
//  TableViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

//  Bugs:
//
//  Sections
//  Left button make orange save & Right button make blue tweet

//  Features to add:
//
//  NJKProgress
//  NJKScroll
//  Sections
//  Favorites Page View
//  Page view app Intro


#import "TableViewController.h"
#import "Post.h"
#import "WebViewController.h"
#import "CommentsViewController.h"
#import "SWTableViewCell.h"

#import "NJKScrollFullscreen.h"                                                                                 //NJKFullScreen
#import "UIViewController+NJKFullScreenSupport.h"                                                               //NJKFullScreen


@interface TableViewController () <SWTableViewCellDelegate, UIScrollViewDelegate, NJKScrollFullscreenDelegate>  //NJKFullScreen (last 2)
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *posts;
@property BOOL showImgs;
@property NSIndexPath *choosenCellPath;
@property NJKScrollFullScreen *scrollProxy;
@property BOOL hideNavBarOnScroll;                                                                              //NJKFullScreen
@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.showImgs = false;
    [self updateTable];

    self.hideNavBarOnScroll = true;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor orangeColor];
    [refresh addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    if (self.hideNavBarOnScroll)
    {
        _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];                                    //NJKFullScreen
        self.tableView.delegate = (id)_scrollProxy;                                                                 //NJKFullScreen
        _scrollProxy.delegate = self;                                                                               //NJKFullScreen
    }
}

#pragma mark -
#pragma mark NJKFullScreen

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

- (void)updateTable
{
    [self getPostsFromApi];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)getPostsFromApi
{
    self.posts = [[NSMutableArray alloc] init];

    NSURL *apiUrl = [NSURL URLWithString:@"http:www.kimonolabs.com/api/7n9nf8aa?apikey=e928b25b9f388d5950b6f620673e010b"];
    NSData *apiData = [NSData dataWithContentsOfURL:apiUrl];
    NSDictionary *apiOutput = [NSJSONSerialization JSONObjectWithData:apiData options:0 error:nil];
    NSDictionary *results = [apiOutput objectForKey:@"results"];
    NSArray *collection1 = [results objectForKey:@"collection1"];

    for (NSDictionary *postBlock in collection1)
    {
        NSString *productLink = [[postBlock objectForKey:@"property2"] objectForKey:@"href"];
        NSString *title = [[postBlock objectForKey:@"property2"] objectForKey:@"text"];
        NSString *subtitle = [postBlock objectForKey:@"property3"];
        NSString *imageLink = [[postBlock objectForKey:@"property4"] objectForKey:@"src"];
        NSString *commentLink = [[postBlock objectForKey:@"property5"] objectForKey:@"href"];

        Post *post = [[Post alloc] initWithproductLink:productLink title:title subtitle:subtitle imageLink:imageLink commentLink:commentLink];
        [self.posts addObject:post];
    }
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.leftUtilityButtons = [self leftButtons];
    cell.delegate = self;

    Post *post = [self.posts objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.subtitle;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;

    if (self.showImgs)
    {
        NSURL *imageURL = [NSURL URLWithString:post.imageLink];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }

    return cell;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];

    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];

    return leftUtilityButtons;
}

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        NSLog(@"Pressed 0 button: save/unsave");
    }
    else if (index == 1)
    {
        NSLog(@"Pressed 1 button tweet");
    }
    else
    {
        self.choosenCellPath = [self.tableView indexPathForCell:cell];
        [self performSegueWithIdentifier:@"CommentSegue" sender:self];
    }
}

// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return true;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choosenCellPath = indexPath;
    [self performSegueWithIdentifier:@"WebDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        Post *selectedPost = [self.posts objectAtIndex:self.choosenCellPath.row];
        WebViewController *webViewController  = segue.destinationViewController;
        webViewController.post = selectedPost;
    }
    else
    {
        Post *selectedPost = [self.posts objectAtIndex:self.choosenCellPath.row];
        CommentsViewController *commentsViewController  = segue.destinationViewController;
        commentsViewController.post = selectedPost;
    }
}

- (IBAction)unwind:(UIStoryboardSegue *)segue
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 63; // 44 is Normal height
}

@end