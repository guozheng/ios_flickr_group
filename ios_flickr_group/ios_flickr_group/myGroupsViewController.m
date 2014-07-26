//
//  myGroupsViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "logInViewController.h"
#import "myGroupsViewController.h"
#import "addGroupsViewController.h"
#import "groupDetalisViewController.h"

#import "myGroupTableViewCell.h"

#import "AppDelegate.h"
#import "FlickrGroupClient.h"
#import "Group.h"

#import "UIImageView+AFNetworking.h"

@interface myGroupsViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FlickrGroupClient *client;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray *groups;

- (void)reload;
- (void)userSignOut;
- (void)joinGroup;

@end

@implementation myGroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.client = [FlickrGroupClient instance];
        self.user = [self.client getCurrentUser];
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set title
    self.navigationItem.title = @"My Groups";
    
    // set background color for nav bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.18 green:0.07 blue:0.32 alpha:0.6]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // set text color for nav bar
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    // sign out button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(userSignOut)];
    
    // join group button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStyleBordered target:self action:@selector(joinGroup)];
    
    // register group table cell
    [self.tableView registerNib:[UINib nibWithNibName:@"myGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"myGroupTableViewCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self reload];
}

#pragma mark internal methods

- (void)reload {
    NSLog(@"reloading groups");
    [self.client getGroupsWithUserId:self.user.id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successfully got groups for user: %@", self.user);
        NSLog(@"responseObject: %@", responseObject);
        NSArray *respGroups = responseObject[@"groups"][@"group"];
        
        // clean up existing self.groups
        self.groups = [[NSMutableArray alloc] initWithCapacity:respGroups.count];
        
        for (id respGroup in respGroups) {
            Group *group = [[Group alloc] init];
            group.id = respGroup[@"nsid"];
            group.name = respGroup[@"name"];
            group.buddyIconUrl = [self.client getBuddyIconUrlWithFarm:respGroup[@"iconfarm"] server:respGroup[@"iconserver"] id:respGroup[@"nsid"]];
            group.memberCount = [NSString stringWithFormat:@"%@ members", respGroup[@"members"]];
            group.photoCount = [NSString stringWithFormat:@"%@ photos", respGroup[@"pool_count"]];
            
            NSLog(@"GROUP: %@", group);
            
            // add to groups
            [self.groups addObject:group];
        }
        
        NSLog(@"self.groups: %@", self.groups);
        
        // reload view
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error getting groups for user: %@", self.user);
        NSLog(@"error details: %@", error);
    }];
}

- (void)joinGroup
{
    NSLog(@"joinGroup Clicked");
    addGroupsViewController* agvc = [[addGroupsViewController alloc] init];
    [self.navigationController pushViewController:agvc animated:YES];
}

- (void) userSignOut
{
    NSLog(@"user sign out");
    [self.client logout];
    
    logInViewController *loginVC = [[logInViewController alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = loginVC;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myGroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"myGroupTableViewCell"];
    
    if (!cell) {
        cell = [[myGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myGroupTableViewCell"];
    }
    
    Group *group = self.groups[indexPath.row];
        
    cell.groupName.text = group.name;
    cell.groupMemberCount.text = group.memberCount;
    cell.groupPhotoCount.text = group.photoCount;
    
    //group buddy icon
    NSURL *imageURL = [NSURL URLWithString:group.buddyIconUrl];
    UIImage *defaultImage = [UIImage imageNamed:@"GroupDefault"];
    cell.groupBuddyIcon.layer.cornerRadius = 10.0;
    cell.groupBuddyIcon.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.groupBuddyIcon.layer.borderWidth = 1.0;
    cell.groupBuddyIcon.layer.masksToBounds = YES;
    [cell.groupBuddyIcon setImageWithURL:imageURL placeholderImage:defaultImage];
    
    NSLog(@"returning cell #%d", indexPath.row);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    groupDetalisViewController* gdvc = [[groupDetalisViewController alloc] init];
    [self.navigationController pushViewController:gdvc animated:YES];
}

@end
