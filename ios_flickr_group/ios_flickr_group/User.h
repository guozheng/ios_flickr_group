//
//  User.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/24/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *realname;
@property (strong, nonatomic) NSString *buddyIconUrl;

@end
