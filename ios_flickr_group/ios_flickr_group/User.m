//
//  User.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/24/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "User.h"

@implementation User

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, username=%@, realname=%@, buddyIconUrl=%@",
            self.id, self.username, self.realname, self.buddyIconUrl];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.realname forKey:@"realname"];
    [encoder encodeObject:self.buddyIconUrl forKey:@"buddyIconUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.realname = [decoder decodeObjectForKey:@"realname"];
        self.buddyIconUrl = [decoder decodeObjectForKey:@"buddyIconUrl"];
    }
    return self;
}

@end
