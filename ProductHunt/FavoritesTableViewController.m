//
//  FavoritesTableViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kFavoritesArray @"favoritesArray"

#import "FavoritesTableViewController.h"
#import "Post.h"
#import "WebViewController.h"

@interface FavoritesTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *savedPosts;
@end

@implementation FavoritesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.savedPosts = [[NSMutableArray alloc] init];
    [self getData];
    NSLog(@"Saved posts: %@", self.savedPosts);
}

#pragma mark -
#pragma mark Persistence

- (void)getData
{
    NSLog(@"GetData Called in FavoritesTableViewController.m");

    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:kFavoritesArray])
    {
        [self.savedPosts addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
}

- (void)setData
{
    NSLog(@"SetData Called");

    NSMutableArray *tempArrayOfPostsAsNSDataObjects = [[NSMutableArray alloc] init];
    for (Post *post in self.savedPosts)
    {
        [tempArrayOfPostsAsNSDataObjects addObject:[NSKeyedArchiver archivedDataWithRootObject:post]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:tempArrayOfPostsAsNSDataObjects forKey:kFavoritesArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.savedPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = self.savedPosts[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavCell" forIndexPath:indexPath];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.subtitle;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.savedPosts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self setData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    UITableViewCell *cell = [self.savedPosts objectAtIndex:fromIndexPath.row];
    [self.savedPosts removeObjectAtIndex:fromIndexPath.row];
    [self.savedPosts insertObject:cell atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FavWebDetailSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.post = [self.savedPosts objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark -
#pragma mark Cell Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 63; // 44 is Normal height
}

@end
