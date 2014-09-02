//
//  topicDetailsViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "topicDetailsViewController.h"
#import "FlickrGroupClient.h"
#import "topicTableViewCell.h"
#import "replyTableViewCell.h"
#import "Topic.h"
#import "Reply.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "FlickrGroupClient.h"
#import "DateUtil.h"

#import "MZFormSheetController.h"
#import "addReplyViewController.h"

@interface topicDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *topicId;
@property (strong, nonatomic) Topic *topic;
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

- (id)initWithTopic:(Topic*)topic
{
    self = [super init];
    if (self) {
        self.topic = topic;
        self.topicId = topic.id;
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
    [self.tableView registerNib: [UINib nibWithNibName:@"topicTableViewCell" bundle:nil] forCellReuseIdentifier:@"topicTableViewCellID"];
    [self.tableView registerNib: [UINib nibWithNibName:@"replyTableViewCell" bundle:nil] forCellReuseIdentifier:@"replyTableViewCellID"];
    
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundBlurEffect:YES];
    [[MZFormSheetController sharedBackgroundWindow] setBlurRadius:5.0];
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundColor:[UIColor clearColor]];
    
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.client = [FlickrGroupClient instance];
    
    [self reload];
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
    if (section == 0) {
        return 1;
    } else {
        return self.replies.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Topic";
    } else {
        return @"Replies";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110.0f;
    } else {
        return 200.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected section=%d, row=%d", indexPath.section, indexPath.row);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        topicTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"topicTableViewCellID"];
        if (cell == nil) {
            cell = [[topicTableViewCell alloc] init];
        }
        cell.subjectLabel.text = self.topic.subject;
        cell.messageLabel.text = self.topic.message;
        [cell.topicAuthorProfileImageView setImageWithURL:[NSURL URLWithString:self.topic.buddyIconUrl]];
        cell.topicAuthorProfileImageView.layer.cornerRadius = cell.topicAuthorProfileImageView.frame.size.height /2;
        cell.topicAuthorProfileImageView.layer.masksToBounds = YES;
        cell.topicAuthorProfileImageView.layer.borderWidth = 2.0;
        cell.topicAuthorProfileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.authorTime.text = [NSString stringWithFormat:@"By %@", self.topic.authorName];
        
        return cell;
    
    } else {
        replyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"replyTableViewCellID"];
        if (cell == nil) {
            cell = [[replyTableViewCell alloc] init];
        }
        Reply* reply = self.replies[indexPath.row];
        cell.authorNameLabel.text = reply.authorName;
        cell.dateCreateLabel.text = [DateUtil getAgeFromDateCreate:reply.dateCreate];
        cell.messageLabel.text = reply.message;
        [cell.buddyIcon setImageWithURL:[NSURL URLWithString:reply.buddyIconUrl]];
        cell.buddyIcon.layer.cornerRadius = cell.buddyIcon.frame.size.height /2;
        cell.buddyIcon.layer.masksToBounds = YES;
        cell.buddyIcon.layer.borderWidth = 2.0;
        cell.buddyIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
        return cell;
    }
}

// customize header view
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:0.02f green:0.68f blue:0.85f alpha:1.0f]];
    
    // Background color
//    header.backgroundView.backgroundColor = [UIColor whiteColor];
}

#pragma mark internal methods
- (void) popVc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) newReply {
    NSLog(@"newReply button clicked");
    addReplyViewController *addReplyVc = [[addReplyViewController alloc] initWithTopic:self.topic];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:addReplyVc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 300);
    formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    formSheet.shadowOpacity = 0.3;
    formSheet.shadowRadius = 2.0;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        NSLog(@"formsheet dismissed!");
        [self reload];
    };
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"formsheet displayed!");
    }];
}

// using 3rd party cocoacontrol MBProgressHUD: https://github.com/matej/MBProgressHUD
- (void)reload {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSLog(@"reloading replies");
        [self.client getTopicRepliesWithTopicId:self.topicId countPerPage:10 pageNum:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // hide loading status
            [hud hide:YES];
            
            NSLog(@"successfully got replies");
            NSLog(@"responseObject: %@", responseObject);
            NSArray *respReplies = responseObject[@"replies"][@"reply"];
            
            // clean up existing self.groups
            self.replies = [[NSMutableArray alloc] initWithCapacity:respReplies.count];
            
            for (id respReply in respReplies) {
                Reply *reply = [[Reply alloc] init];
                reply.id = respReply[@"id"];
                reply.message = respReply[@"message"][@"_content"];
                reply.authorId = respReply[@"author"];
                reply.authorName = respReply[@"authorname"];
                reply.buddyIconUrl = [self.client getBuddyIconUrlWithFarm:respReply[@"iconfarm"] server:respReply[@"iconserver"] id:reply.authorId];
                reply.dateCreate = [respReply[@"datecreate"] intValue];
                
                NSLog(@"REPLY: %@", reply);
                
                // add to groups
                [self.replies addObject:reply];
            }
            
            NSLog(@"self.replies: %@", self.replies);
            NSLog(@"self.replies count: %d", self.replies.count);
            
            // reload view
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // hide loading status
            [hud hide:YES];
            
            NSLog(@"error getting replies");
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
