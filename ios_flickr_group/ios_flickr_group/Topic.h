//
//  Topic.h
//  ios_flickr_group
//
//  Created by Li Li on 7/27/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* subject;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* authorId;
@property (strong, nonatomic) NSString* authorName;
@property (strong, nonatomic) NSString* lastReply;
@property (strong, nonatomic) NSString* buddyIconUrl;
@end
