//
//  myGroupTableViewCell.h
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myGroupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *groupProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupDescLabel;
@end
