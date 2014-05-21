//
//  ViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 5/14/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "ViewController.h"
#import "Post.h"
#import "WebViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *posts;
@property BOOL showImgs;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.posts = [[NSMutableArray alloc] init];
    self.showImgs = true;

    NSURL *apiUrl = [NSURL URLWithString:@"http:www.kimonolabs.com/api/7n9nf8aa?apikey=e928b25b9f388d5950b6f620673e010b"];
    NSData *apiData = [NSData dataWithContentsOfURL:apiUrl];
    NSDictionary *apiOutput = [NSJSONSerialization JSONObjectWithData:apiData options:0 error:nil];

    //self.posts = [dataDictionary objectForKey:@"posts"];
    NSDictionary *results = [apiOutput objectForKey:@"results"];
    NSArray *collection1 = [results objectForKey:@"collection1"];
//    NSLog(@"%@",collection1);

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCellID"];
    Post *post = [self.posts objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.subtitle;

    if (self.showImgs)
    {
        NSURL *imageURL = [NSURL URLWithString:post.imageLink];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
    Post *selectedPost = [self.posts objectAtIndex:selectedRow];
    WebViewController *webViewController  = segue.destinationViewController;
    webViewController.post = selectedPost;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

@end


