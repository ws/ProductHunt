//
//  TestTwoViewController.m
//  ProductHunt
//
//  Created by Sapan Bhuta on 6/2/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "TestTwoViewController.h"

@interface TestTwoViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TestTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    cell.textLabel.text = @"Two";
    return cell;
}

@end
