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

@import Twitter;

@interface TableViewController () <UIAlertViewDelegate, SWTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *posts;
@property NSIndexPath *choosenCellPath;
@property NSMutableArray *savedPosts;
@property BOOL firstTimeLoad;
@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];
    [self updateTable];
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor orangeColor];
    [refresh addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

#pragma mark - Fetch Data from API & Update Table

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

#pragma mark - Required Table View Methods

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

    return cell;
}

#pragma mark - Custom Methods for on Swipe Buttons

- (NSArray *)leftButtonsGrey:(Post *)post
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor grayColor]
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

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor orangeColor]
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

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return true;
}

#pragma mark - Persistence

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

#pragma mark - Segue / Transitions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choosenCellPath = indexPath;
    [self performSegueWithIdentifier:@"WebDetailSegue" sender:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection)
    {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getData];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setData];
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

#pragma mark - Cell Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 63; // 44 is Normal height
}

#pragma mark - Check if saved

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