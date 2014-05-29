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
@end

@implementation FavoritesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self getData];

    NSLog(@"%@",self.savedPosts);
}

- (void)getData
{
    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:kFavoritesArray])
    {
        [self.savedPosts addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.savedPosts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
        Post *selectedPost = [self.savedPosts objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.post = selectedPost;
}

#pragma mark -
#pragma mark Cell Height

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 63; // 44 is Normal height
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
