//
//  myGroupTableViewCell.h
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface myGroupTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *groupBuddyIcon;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCount;
@property (weak, nonatomic) IBOutlet UILabel *groupPhotoCount;
@property (weak, nonatomic) IBOutlet UIImageView *is18plus;
@property (weak, nonatomic) IBOutlet UIImageView *isInvitationOnly;
@property (strong, nonatomic) NSIndexPath* indexPath;

@end
