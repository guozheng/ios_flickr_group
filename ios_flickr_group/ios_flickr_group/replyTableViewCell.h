//
//  topicTableViewCell.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 8/16/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface replyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *buddyIcon;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
