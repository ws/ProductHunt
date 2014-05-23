//
//  TableViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

//  Features to add:
//
//  Intro Page View
//  Slide on cell to save link


#import "TableViewController.h"
#import "Post.h"
#import "WebViewController.h"
#import "CommentsViewController.h"

@interface TableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *posts;
@property BOOL showImgs;
@property NSIndexPath *longPressPath;
@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.showImgs = false;
    [self updateTable];

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor orangeColor];
    [refresh addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.5; //seconds
    [self.tableView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    self.longPressPath = indexPath;
    if (indexPath != nil)
    {
        [self performSegueWithIdentifier:@"CommentSegue" sender:self];              //ERROR
    }
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCellID"];
    Post *post = [self.posts objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
//    cell.textLabel.textColor = [UIColor orangeColor];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
        Post *selectedPost = [self.posts objectAtIndex:selectedRow];
        WebViewController *webViewController  = segue.destinationViewController;
        webViewController.post = selectedPost;
    }
    else
    {
        NSInteger selectedRow = self.longPressPath.row;
        Post *selectedPost = [self.posts objectAtIndex:selectedRow];
        CommentsViewController *commentsViewController  = segue.destinationViewController;
        commentsViewController.post = selectedPost;

        NSLog(@"%@",selectedPost.productLink);
        NSLog(@"%@",selectedPost.commentLink);
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