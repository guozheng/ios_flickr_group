//
//  myGroupsViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "myGroupsViewController.h"
#import "addGroupsViewController.h"
#import "myGroupTableViewCell.h"

@interface myGroupsViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib: [UINib nibWithNibName:@"myGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"myGroupTableViewCell"];
    myGroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"myGroupTableViewCell"];
    
    cell.groupNameLabel.text = [NSString stringWithFormat:@"Group #%d", indexPath.row];
    cell.groupDescLabel.text = [NSString stringWithFormat:@"this is description for Group #%d", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

@end
