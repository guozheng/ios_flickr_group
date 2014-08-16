//
//  groupDetailsTableViewCell.h
//  ios_flickr_group
//
//  Created by Li Li on 7/20/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface topicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topicAuthorProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTime;

@end
