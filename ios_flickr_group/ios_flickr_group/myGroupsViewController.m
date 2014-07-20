//
//  myGroupsViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "myGroupsViewController.h"
#import "addGroupsViewController.h"

@interface myGroupsViewController ()

@end

@implementation myGroupsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"My Groups";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(joinNewGroup)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)joinNewGroup
{
    NSLog(@"joinNewGroup Clicked");
    addGroupsViewController* agvc = [[addGroupsViewController alloc] init];
    [self.navigationController pushViewController:agvc animated:YES];
}

@end
