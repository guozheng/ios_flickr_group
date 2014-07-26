//
//  Group.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/25/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *buddyIconUrl;
@property (strong, nonatomic) NSString *memberCount;
@property (strong, nonatomic) NSString *photoCount;

@end
