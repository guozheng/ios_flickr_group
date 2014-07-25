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

// note that buddyIconUrl constructed not necessarily exist,
// in that case, use the default buddy icons, e.g.
// https://s.yimg.com/pw/images/buddyicon01.png, from 01 to 11.
@property (strong, nonatomic) NSString *buddyIconUrl;

@end
