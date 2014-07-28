//
//  addGroupsViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "addGroupsViewController.h"
#import "myGroupTableViewCell.h"
#import "groupDetalisViewController.h"

#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "FlickrGroupClient.h"
#import "Group.h"
#import "SWTableViewCell.h"
#import "NSMutableArray+SWUtilityButtons.h"




@interface addGroupsViewController ()
@property (strong, nonatomic) UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* groups;
@property (strong, nonatomic) FlickrGroupClient* client;
@property (strong, nonatomic) UIRefreshControl* refresh;
@property (strong, nonatomic) NSString* keyword;
@end

@implementation addGroupsViewController

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
    
    self.navigationItem.title = @"New Groups";
    
    // the default search keyword
    self.keyword = @"Yahoo";
    
    // search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.searchBar.placeholder = self.keyword;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // register group table cell
    [self.tableView registerNib:[UINib nibWithNibName:@"myGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"myGroupTableViewCell"];
    
    self.groups = [[NSMutableArray alloc] init];
    
    // pull to refresh and load again
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refresh];
    
    self.client = [FlickrGroupClient instance];
    
    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myGroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"myGroupTableViewCell"];
        
    NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc] init];

    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07f green:0.75f blue:0.16 alpha:1.0f] title:@"Join"];
    
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
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
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // if the search bar is active, resign it
    [self.searchBar resignFirstResponder];
    
    Group* group = self.groups[indexPath.row];
    groupDetalisViewController* gdvc = [[groupDetalisViewController alloc] initWithGroupId:group.groupId];
    [self.navigationController pushViewController:gdvc animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    NSLog(@"did end editing!");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.keyword = [searchBar text];
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    
    [self reload];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - SWTableViewCell

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"Join button was pressed");
            Group* group = self.groups[((myGroupTableViewCell*)cell).indexPath.row];
            NSLog(@"%@", group);
            [self.client joinGroupWithGroupId:group.groupId success:^(AFHTTPRequestOperation *operation, id responseObject) {
                // hide loading status
                //[hud hide:YES];
                
                NSLog(@"successfully join group!");
                NSLog(@"responseObject: %@", responseObject);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // hide loading status
                //[hud hide:YES];
                
                NSLog(@"error join group");
                NSLog(@"error details: %@", error);
            }];
        }
            break;
        case 1:
            
            break;
    }
}

#pragma mark - internal functions
// using 3rd party cocoacontrol MBProgressHUD: https://github.com/matej/MBProgressHUD
- (void)reload {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSLog(@"reloading groups");
        [self.client searchGroupsWithKeyword:self.keyword success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // hide loading status
            [hud hide:YES];
            
            NSLog(@"successfully searched groups");
            NSLog(@"responseObject: %@", responseObject);
            NSArray *respGroups = responseObject[@"groups"][@"group"];
            
            // clean up existing self.groups
            self.groups = [[NSMutableArray alloc] initWithCapacity:respGroups.count];
            
            for (id respGroup in respGroups) {
                Group *group = [[Group alloc] init];
                group.groupId = respGroup[@"nsid"];
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
            
            NSLog(@"error searching groups");
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


@end
