//
//  myGroupTableViewCell.m
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "myGroupTableViewCell.h"

@interface myGroupTableViewCell ()


@end

@implementation myGroupTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.groupName.textColor = [UIColor colorWithRed:0.02f green:0.68f blue:0.85f alpha:1.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
