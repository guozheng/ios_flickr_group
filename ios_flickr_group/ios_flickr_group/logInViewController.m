//
//  logInViewController.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "logInViewController.h"
#import "myGroupsViewController.h"

@interface logInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
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
    
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.passwordTextField.secureTextEntry = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* hide keyboard when clicking elsewhere on the view */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

/* hide keyboard when hit return key or click on return */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return NO;
    
}

- (IBAction)OnLoginClick:(id)sender {
    NSLog(@"Login Button Clicked");
    
    myGroupsViewController* mgvc = [[myGroupsViewController alloc] init];
    
    [self.navigationController pushViewController:mgvc animated:YES];
    
}
- (IBAction)OnRegisterClick:(id)sender {
}
@end
