//
//  Group.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/25/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Group.h"

@implementation Group

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, name=%@, buddyIconUrl=%@", self.id, self.name, self.buddyIconUrl];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.buddyIconUrl forKey:@"buddyIconUrl"];
    [encoder encodeObject:self.memberCount forKey:@"memberCount"];
    [encoder encodeObject:self.photoCount forKey:@"photoCount"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.buddyIconUrl = [decoder decodeObjectForKey:@"buddyIconUrl"];
        self.memberCount = [decoder decodeObjectForKey:@"memberCount"];
        self.photoCount = [decoder decodeObjectForKey:@"photoCount"];
    }
    return self;
}

@end
