//
//  topicDetailsViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "topicDetailsViewController.h"
#import "FlickrGroupClient.h"

@interface topicDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *topicId;
@property (strong, nonatomic) NSMutableArray *replies;
@property (strong, nonatomic) FlickrGroupClient *client;
@property (strong, nonatomic) UIRefreshControl* refresh;

@end

@implementation topicDetailsViewController

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
    
    self.navigationItem.title = @"Replies";
    
    // set background color for nav bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.18 green:0.07 blue:0.32 alpha:0.6];
    self.navigationController.navigationBar.translucent = YES; // default is YES
    
    // set nav bar title text color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor yellowColor]};
    
    // set text color for nav bar button item text
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // back bar button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
    [backButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popVc) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // new topic bar button
    UIButton *newDiscussionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
    [newDiscussionButton setImage:[UIImage imageNamed:@"NewReply"] forState:UIControlStateNormal];
    [newDiscussionButton addTarget:self action:@selector(newReply) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newDiscussionButton];
    
    // register nib file for group details table view cell
//    [self.tableView registerNib: [UINib nibWithNibName:@"groupDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupDetailsTableViewCellID"];
    
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.client = [FlickrGroupClient instance];
    
//    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource protocol methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.replies.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

#pragma mark internal methods
- (void) popVc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) newReply {
    NSLog(@"newReply button clicked");
}



@end
