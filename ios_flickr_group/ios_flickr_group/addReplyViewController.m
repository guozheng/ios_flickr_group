//
//  addReplyViewController.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 8/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "addReplyViewController.h"
#import "FlickrGroupClient.h"
#import "Topic.h"
#import "MZFormSheetController.h"

@interface addReplyViewController ()

@property (strong, nonatomic) NSString *topicId;
@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) FlickrGroupClient *client;

@end

@implementation addReplyViewController

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
    
    [self.replyInputTextField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.replyInputTextField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.replyInputTextField.layer setBorderWidth: 1.0];
    [self.replyInputTextField.layer setCornerRadius:8.0f];
    [self.replyInputTextField.layer setMasksToBounds:YES];
    
    self.client = [FlickrGroupClient instance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"Cancelled new reply, done the formsheet controller, bye!");
    }];
}

- (IBAction)resetAction:(id)sender {
    self.replyInputTextField.text = @"";
}

- (IBAction)submitAction:(id)sender {
    [self.client addTopicReplyWithTopicId:self.topicId message:self.replyInputTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully created reply");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error creating reply, %@", error);
    }];
    
    // dismiss formsheet controller
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"Submitted a new reply, done with the formsheet controller, bye!");
    }];
}
@end
