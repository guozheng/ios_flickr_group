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
    return [NSString stringWithFormat:@"id=%@, name=%@, buddyIconUrl=%@, is18plus=%d, isInvitationOnly=%d", self.groupId, self.name, self.buddyIconUrl, self.is18plus, self.isInvitationOnly];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.groupId forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.buddyIconUrl forKey:@"buddyIconUrl"];
    [encoder encodeObject:self.memberCount forKey:@"memberCount"];
    [encoder encodeObject:self.photoCount forKey:@"photoCount"];
    [encoder encodeBool:self.is18plus forKey:@"is18plus"];
    [encoder encodeBool:self.isInvitationOnly forKey:@"isInvitationOnly"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.groupId = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.buddyIconUrl = [decoder decodeObjectForKey:@"buddyIconUrl"];
        self.memberCount = [decoder decodeObjectForKey:@"memberCount"];
        self.photoCount = [decoder decodeObjectForKey:@"photoCount"];
        self.is18plus = [decoder decodeBoolForKey:@"is18plus"];
        self.isInvitationOnly = [decoder decodeBoolForKey:@"isInvitationOnly"];
    }
    return self;
}

@end
