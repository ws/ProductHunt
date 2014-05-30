//
//  TableViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kFavoritesArray @"favoritesArray"
#define kAPI @"http://www.kimonolabs.com/api/7n9nf8aa?apikey=e928b25b9f388d5950b6f620673e010b"

#import "TableViewController.h"
#import "Post.h"
#import "WebViewController.h"
#import "CommentsViewController.h"
#import "SWTableViewCell.h"
#import "NJKScrollFullscreen.h"                                                                                 //NJKFullScreen
#import "UIViewController+NJKFullScreenSupport.h"                                                               //NJKFullScreen
@import Twitter;

@interface TableViewController () <UIAlertViewDelegate, SWTableViewCellDelegate, UIScrollViewDelegate, NJKScrollFullscreenDelegate> //NJK (last 2)
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSMutableArray *posts;
@property NSIndexPath *choosenCellPath;
@property NJKScrollFullScreen *scrollProxy;                                                                     //NJKFullScreen
@property NSMutableArray *savedPosts;
@end

@implementation TableViewController

- (void)viewDidLoad
{
    NSLog(@"View Did Load");
    [super viewDidLoad];
    [self getData];
    [self updateTable];
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.activityIndicator stopAnimating];

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor orangeColor];
    [refresh addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    if (YES)                                                                                                     //NJKFullScreen
    {                                                                                                           //NJKFullScreen
        _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];                                //NJKFullScreen
        self.tableView.delegate = (id)_scrollProxy;                                                             //NJKFullScreen
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
#pragma mark Fetch Data from API & Update Table

- (void)updateTable
{
    [self getPostsFromApi];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)getPostsFromApi
{
    self.posts = [[NSMutableArray alloc] init];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kAPI]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         //start load activity indicator
         NSDictionary *output = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
         NSArray *collection1 = output[@"results"][@"collection1"];

         for (NSDictionary *postBlock in collection1)
         {
             NSString *productLink = postBlock[@"property2"][@"href"];
             NSString *title = postBlock[@"property2"][@"text"];
             NSString *subtitle = postBlock[@"property3"];
             NSString *commentLink = postBlock[@"property4"][@"href"];
             NSString *imageLink = postBlock[@"property5"][@"src"];

             Post *post = [[Post alloc] initWithproductLink:productLink
                                                      title:title
                                                   subtitle:subtitle
                                                  imageLink:imageLink
                                                commentLink:commentLink];
             [self.posts addObject:post];
         }
         [self.tableView reloadData];
     }];
}

#pragma mark -
#pragma mark Required Table View Methods

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Post *post = [self.posts objectAtIndex:indexPath.row];

    if ([self isSaved:post])
    {
        cell.leftUtilityButtons = [self leftButtonsOrange:post];
    }
    else
    {
        cell.leftUtilityButtons = [self leftButtonsGrey:post];
    }

    cell.delegate = self;

    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.subtitle;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;

    if (NO)
    {
        NSURL *imageURL = [NSURL URLWithString:post.imageLink];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }

    return cell;
}

#pragma mark -
#pragma mark Custom Methods for on Swipe Buttons

- (NSArray *)leftButtonsGrey:(Post *)post
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.50f green:0.50f blue:0.50f alpha:1.0]
                                                icon:[UIImage imageNamed:@"smallstar.png"]];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]
                                                icon:[UIImage imageNamed:@"twitter.png"]];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"comment.png"]];

    return leftUtilityButtons;
}

- (NSArray *)leftButtonsOrange:(Post *)post
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:255/255.0f green:147/255.0f blue:39/255.0f alpha:1.0f]
                                                icon:[UIImage imageNamed:@"smallstar.png"]];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]
                                                icon:[UIImage imageNamed:@"twitter.png"]];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"comment.png"]];

    return leftUtilityButtons;
}

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        Post *post = self.posts[[self.tableView indexPathForCell:cell].row];
        if ([self isSaved:post])
        {
            for (Post *iteratedPost in self.savedPosts)
            {
                if ([iteratedPost.productLink isEqualToString:post.productLink])
                {
                    [self.savedPosts removeObject:iteratedPost];
                    break;
                }
            }
            cell.leftUtilityButtons = nil;
            cell.leftUtilityButtons = [self leftButtonsGrey:post];
        }
        else
        {
            [self.savedPosts addObject:post];
            cell.leftUtilityButtons = nil;
            cell.leftUtilityButtons = [self leftButtonsOrange:post];
        }
        [self setData];
    }
    else if (index == 1)
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            Post *post = [self.posts objectAtIndex:[self.tableView indexPathForCell:cell].row];
            NSString *url = post.productLink;
            NSString *title = post.title;
            NSString *subtitle = post.subtitle;
            NSString *text = [@"Check out: " stringByAppendingString:[[title stringByAppendingString:@" - "] stringByAppendingString:subtitle]];

            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:text];
            [tweetSheet addURL:[NSURL URLWithString:url]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"                                                   
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if (index == 2)
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

#pragma mark -
#pragma mark Persistence

- (void)getData
{
    self.savedPosts = [[NSMutableArray alloc] init];

    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:kFavoritesArray])
    {
        [self.savedPosts addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
}

- (void)setData
{
    NSMutableArray *tempArrayOfPostsAsNSDataObjects = [[NSMutableArray alloc] init];

    for (Post *post in self.savedPosts)
    {
        [tempArrayOfPostsAsNSDataObjects addObject:[NSKeyedArchiver archivedDataWithRootObject:post]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempArrayOfPostsAsNSDataObjects forKey:kFavoritesArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Segue / Transitions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choosenCellPath = indexPath;
    [self performSegueWithIdentifier:@"WebDetailSegue" sender:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Reloading Data");
    [self getData];
    [self.tableView reloadData];                                                                                //May be unnecessary

    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection)
    {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WebDetailSegue"])
    {
        Post *selectedPost = [self.posts objectAtIndex:self.choosenCellPath.row];
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.post = selectedPost;
    }
    else if ([segue.identifier isEqualToString:@"CommentSegue"])
    {
        Post *selectedPost = [self.posts objectAtIndex:self.choosenCellPath.row];
        UINavigationController *navigationController = segue.destinationViewController;
        CommentsViewController *commentsViewController = [navigationController.viewControllers objectAtIndex:0];
        commentsViewController.post = selectedPost;
    }
    else
    {
        //Segue to FavoritesTableViewController.m"
    }
}

- (IBAction)unwind:(UIStoryboardSegue *)segue
{
}

#pragma mark -
#pragma mark Cell Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 63; // 44 is Normal height
}

#pragma mark -
#pragma mark Check if saved

- (BOOL)isSaved:(Post *)postToCheck
{
    for (Post *savedPost in self.savedPosts)
    {
        if ([postToCheck.productLink isEqualToString:savedPost.productLink])
        {
            return true;
        }
    }
    return false;
}


@end