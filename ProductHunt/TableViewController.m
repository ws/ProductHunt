//
//  TableViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kFavoritesArray @"favorites"
#define kPost @"Post"

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
@property NSMutableArray *posts;
@property NSIndexPath *choosenCellPath;
@property NJKScrollFullScreen *scrollProxy;                                                                     //NJKFullScreen
@property NSMutableArray *savedPosts;
@property BOOL setOrange;
@property BOOL showImgs;
@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    [self.savedPosts addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:kFavoritesArray]]; //check if nill issue

    self.setOrange = NO;
    self.showImgs = NO;
    [self updateTable];

    self.clearsSelectionOnViewWillAppear = YES;                                                                 //FixSelectionBug
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor orangeColor];
    [refresh addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    if (YES)                                                                                                    //NJKFullScreen
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

    NSURL *url = [NSURL URLWithString:@"http://www.kimonolabs.com/api/7n9nf8aa?apikey=e928b25b9f388d5950b6f620673e010b"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
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
         //stop load activity indicator
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

#pragma mark -
#pragma mark Custom Methods for on Swipe Buttons

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    UIColor *orangeOrGray;

    if (self.setOrange)
    {
        orangeOrGray = [UIColor colorWithRed:255/255.0f green:147/255.0f blue:39/255.0f alpha:1.0f];
    }
    else
    {
        orangeOrGray = [UIColor colorWithRed:0.50f green:0.50f blue:0.50f alpha:1.0];
    }

    [leftUtilityButtons sw_addUtilityButtonWithColor:orangeOrGray icon:[UIImage imageNamed:@"smallstar.png"]];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] icon:[UIImage imageNamed:@"twitter.png"]];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0] icon:[UIImage imageNamed:@"comment.png"]];

    return leftUtilityButtons;
}


// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        Post *post = self.posts[[self.tableView indexPathForCell:cell].row];
        if (post.saved)
        {
            NSLog(@"unsaving post");
            [self.savedPosts removeObject:post];
            post.saved = NO;
            self.setOrange = NO;
            cell.leftUtilityButtons = nil;
            cell.leftUtilityButtons = [self leftButtons];
        }
        else
        {
            NSLog(@"saving post");
            [self.savedPosts addObject:post];
            post.saved = YES;
            self.setOrange = YES;
            cell.leftUtilityButtons = nil;
            cell.leftUtilityButtons = [self leftButtons];
        }

        //loop over self.posts to create an array that mirrors it but with NSData objects then pass to standardUserDefaults
        NSMutableArray *tempArrayOfPostsAsDataObjects = [[NSMutableArray alloc] init];
        for (Post *post in self.posts)
        {
            [tempArrayOfPostsAsDataObjects addObject:[NSKeyedArchiver archivedDataWithRootObject:post]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:tempArrayOfPostsAsDataObjects forKey:kFavoritesArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
//            [tweetSheet addImage:[UIImage imageNamed:self.imageString]];
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
#pragma mark Segue / Transitions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choosenCellPath = indexPath;
    [self performSegueWithIdentifier:@"WebDetailSegue" sender:self];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];

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
    else
    {
        Post *selectedPost = [self.posts objectAtIndex:self.choosenCellPath.row];
        UINavigationController *navigationController = segue.destinationViewController;
        CommentsViewController *commentsViewController = [navigationController.viewControllers objectAtIndex:0];
        commentsViewController.post = selectedPost;
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

@end