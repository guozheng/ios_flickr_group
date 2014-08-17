//
//  topicDetailsViewController.h
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface topicDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(id)initWithTopic:(Topic*)topic;

@end
