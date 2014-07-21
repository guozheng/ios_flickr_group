//
//  addGroupsViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "addGroupsViewController.h"
#import "addGroupTableViewCell.h"
#import "groupDetalisViewController.h"

@interface addGroupsViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib: [UINib nibWithNibName:@"addGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"addGroupTableViewCellID"];
    addGroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"addGroupTableViewCellID"];
    
    if (cell == nil)
        cell = [[addGroupTableViewCell alloc] init];
    
    cell.groupNameLabel.text = [NSString stringWithFormat:@"Group #%d", indexPath.row];
    cell.groupDescLabel.text = [NSString stringWithFormat:@"this is description for Group #%d", indexPath.row];
    
    cell.memberCountLabel.text = @"Members: 50";
    cell.topicCountLabel.text = @"topics: 69";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    groupDetalisViewController* gdvc = [[groupDetalisViewController alloc] init];
    [self.navigationController pushViewController:gdvc animated:YES];
}


@end
