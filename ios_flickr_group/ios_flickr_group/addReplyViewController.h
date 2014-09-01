//
//  addReplyViewController.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 8/30/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface addReplyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *replyInputTextField;

- (IBAction)cancelAction:(id)sender;

- (IBAction)resetAction:(id)sender;

- (IBAction)submitAction:(id)sender;

- (id)initWithTopic:(Topic*)topic;

@end
