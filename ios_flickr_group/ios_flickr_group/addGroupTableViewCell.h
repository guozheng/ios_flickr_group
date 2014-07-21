//
//  addGroupTableViewCell.h
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groupProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end
