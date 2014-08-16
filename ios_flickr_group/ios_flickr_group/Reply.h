//
//  Reply.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 8/16/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reply : NSObject

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* authorId;
@property (strong, nonatomic) NSString* authorName;
@property (strong, nonatomic) NSString* buddyIconUrl;
@property int dateCreate;

@end
