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
#import "MBProgressHUD.h"

@interface myGroupsViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FlickrGroupClient *client;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSMutableArray *groups;

@property (strong, nonatomic) UIRefreshControl *refresh;

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
    [self.navigationController.navigationBar setTranslucent:YES];
    
    // set text color for nav bar
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    // sign out button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(userSignOut)];
    
    // join group button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStyleBordered target:self action:@selector(joinGroup)];
    
    // register group table cell
    [self.tableView registerNib:[UINib nibWithNibName:@"myGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"myGroupTableViewCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // pull to refresh and load again
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refresh];
    [self reload];
    
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

// using 3rd party cocoacontrol MBProgressHUD: https://github.com/matej/MBProgressHUD
- (void)reload {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSLog(@"reloading groups");
        [self.client getGroupsWithUserId:self.user.id success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // hide loading status
            [hud hide:YES];
            
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
                group.is18plus = [respGroup[@"eighteenplus"] boolValue];
                group.isInvitationOnly = [respGroup[@"invitation_only"] boolValue];
                
                NSLog(@"GROUP: %@", group);
                
                // add to groups
                [self.groups addObject:group];
            }
            
            NSLog(@"self.groups: %@", self.groups);
            
            // reload view
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // hide loading status
            [hud hide:YES];
            
            NSLog(@"error getting groups for user: %@", self.user);
            NSLog(@"error details: %@", error);
        }];
        
        if (self.refresh != nil && self.refresh.isRefreshing == YES) {
            [self.refresh endRefreshing];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
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
    
    //show or hide 18plus and inviationOnly icons
    cell.is18plus.hidden = !group.is18plus;
    cell.isInvitationOnly.hidden = !group.isInvitationOnly;
    
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
    [self.searchBar resignFirstResponder];
    
    groupDetalisViewController* gdvc = [[groupDetalisViewController alloc] init];
    [self.navigationController pushViewController:gdvc animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    NSLog(@"did end editing!");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString* keyword = [searchBar text];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    
}


@end
