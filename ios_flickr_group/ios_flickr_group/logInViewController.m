//
//  logInViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "logInViewController.h"
#import "myGroupsViewController.h"
#import "FlickrGroupClient.h"

@interface logInViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *logInButton;
- (IBAction)OnLoginClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)OnRegisterClick:(id)sender;

@end

@implementation logInViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnLoginClick:(id)sender {
    NSLog(@"Login button clicked");
    
    [[FlickrGroupClient instance] login];
    
}
- (IBAction)OnRegisterClick:(id)sender {
    NSLog(@"Register button clicked");
}
@end
