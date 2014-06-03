//  
//  FavoritesTableViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//


#define kFavoritesArray @"favoritesArray"

#import "FavoritesTableViewController.h"
#import "WebViewController.h"
#import "Post.h"

@interface FavoritesTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *savedPosts;
@end

@implementation FavoritesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setData];
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
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;

    return cell;
}

- (IBAction)onPressEditButton:(id)sender
{
    if ([self.tableView isEditing])
    {
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit"];
    }
    else
    {
        [self.tableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done"];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //change to YES to get delete swipe on cell
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FavWebDetailSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.post = [self.savedPosts objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark - Deselection fix

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection)
    {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getData];
    [self.tableView reloadData];
}

#pragma mark - Cell Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63; // 44 is Normal height
}

@end
