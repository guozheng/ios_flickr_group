//
//  addTopicViewController.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 9/1/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addTopicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *subjectInput;
@property (weak, nonatomic) IBOutlet UITextView *messageInput;

- (IBAction)cancelAction:(id)sender;
- (IBAction)resetAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@property (strong, nonatomic) NSString *groupId;

@end
