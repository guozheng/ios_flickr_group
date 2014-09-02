//
//  addTopicViewController.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 9/1/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "addTopicViewController.h"
#import "FlickrGroupClient.h"
#import "MZFormSheetController.h"

@interface addTopicViewController ()

@property (strong, nonatomic) FlickrGroupClient *client;

@end

@implementation addTopicViewController

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
    
    [self.messageInput.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [self.messageInput.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.messageInput.layer setBorderWidth: 1.0f];
    [self.messageInput.layer setCornerRadius: 8.0f];
    [self.messageInput.layer setMasksToBounds:YES];
    
    self.client = [FlickrGroupClient instance];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"Cancelled new topic, done the formsheet controller, bye!");
    }];
}

- (IBAction)resetAction:(id)sender {
    // reset message only
    self.messageInput.text = @"";
}

- (IBAction)submitAction:(id)sender {
    [self.client addTopicWithGroupId:self.groupId subject:self.subjectInput.text message:self.messageInput.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully created a new topic");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error creating a new topic, %@", error);
    }];
    
    // dismiss formsheet controller
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"Created a new topic, done with the formsheet controller, bye!");
    }];
}
@end
