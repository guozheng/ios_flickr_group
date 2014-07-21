//
//  groupDetalisViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "groupDetalisViewController.h"
#import "topicDetailsViewController.h"
#import "groupDetailsTableViewCell.h"

@interface groupDetalisViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation groupDetalisViewController

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
    
    self.navigationItem.title = @"Discussions";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewDiscussion)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createNewDiscussion
{
    NSLog(@"createNewDiscussion clicked!");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib: [UINib nibWithNibName:@"groupDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupDetailsTableViewCellID"];
    groupDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"groupDetailsTableViewCellID"];
    
    if (cell == nil)
        cell = [[groupDetailsTableViewCell alloc] init];
    
    cell.topicNameLabel.text = [NSString stringWithFormat:@"Topic #%d", indexPath.row];
    cell.topicDescLabel.text = [NSString stringWithFormat:@"this is description for topic #%d", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    topicDetailsViewController* gdvc = [[topicDetailsViewController alloc] init];
    [self.navigationController pushViewController:gdvc animated:YES];
}


@end
