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

#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "FlickrGroupClient.h"
#import "Topic.h"

@interface groupDetalisViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString* groupId;
@property (strong, nonatomic) NSMutableArray* topics;
@property (strong, nonatomic) FlickrGroupClient* client;
@property (strong, nonatomic) UIRefreshControl* refresh;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecognizer;
- (IBAction)onSwipe:(id)sender;

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

-(id)initWithGroupId:(NSString*)groupId
{
    self = [super init];
    if (self){
        self.groupId = groupId;
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
    
    self.client = [FlickrGroupClient instance];
    
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft;
    
    [self reload];
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
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerNib: [UINib nibWithNibName:@"groupDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupDetailsTableViewCellID"];
    groupDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"groupDetailsTableViewCellID"];
    
    if (cell == nil)
        cell = [[groupDetailsTableViewCell alloc] init];
    
    Topic* topic = self.topics[indexPath.row];
    
    cell.subjectLabel.text = topic.subject;
    cell.messageLabel.text = topic.message;
    [cell.topicAuthorProfileImageView setImageWithURL:[NSURL URLWithString:topic.buddyIconUrl]];
    cell.authorTime.text = [NSString stringWithFormat:@"By %@", topic.authorName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    topicDetailsViewController* gdvc = [[topicDetailsViewController alloc] init];
    [self.navigationController pushViewController:gdvc animated:YES];
}


#pragma mark - internal functions
// using 3rd party cocoacontrol MBProgressHUD: https://github.com/matej/MBProgressHUD
- (void)reload {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSLog(@"reloading groups");
        [self.client getGroupTopicsWithGroupId:self.groupId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // hide loading status
            [hud hide:YES];
            
            NSLog(@"successfully searched groups");
            NSLog(@"responseObject: %@", responseObject);
            NSArray *respTopics = responseObject[@"topics"][@"topic"];
            
            // clean up existing self.groups
            self.topics = [[NSMutableArray alloc] initWithCapacity:respTopics.count];
            
            for (id respTopic in respTopics) {
                Topic *topic = [[Topic alloc] init];
                topic.id = respTopic[@"id"];
                topic.subject = respTopic[@"subject"];
                topic.message = respTopic[@"message"][@"_content"];
                topic.authorId = respTopic[@"author"];
                topic.authorName = respTopic[@"authorname"];
                topic.buddyIconUrl = [self.client getBuddyIconUrlWithFarm:respTopic[@"iconfarm"] server:respTopic[@"iconserver"] id:topic.authorId];
                
                NSLog(@"TOPIC: %@", topic);
                
                // add to groups
                [self.topics addObject:topic];
            }
            
            NSLog(@"self.topics: %@", self.topics);
            NSLog(@"self.topic count: %d", self.topics.count);
            
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

- (IBAction)onSwipe:(id)sender {
    NSLog(@"swipe!");
}
@end
