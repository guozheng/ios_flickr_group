//
//  Topic.m
//  ios_flickr_group
//
//  Created by Li Li on 7/27/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, subject=%@, message=%@, authorId=%@, authorName=%@, lastReply=%@, buddyIconUrl=%@", self.id, self.subject, self.message, self.authorId, self.authorName, self.lastReply, self.buddyIconUrl];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.subject forKey:@"subject"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:self.authorId forKey:@"authorId"];
    [encoder encodeObject:self.authorName forKey:@"authorName"];
    [encoder encodeObject:self.lastReply forKey:@"lastReply"];
    [encoder encodeObject:self.buddyIconUrl forKey:@"buddyIconUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.subject = [decoder decodeObjectForKey:@"subject"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.authorId = [decoder decodeObjectForKey:@"authorId"];
        self.authorName = [decoder decodeObjectForKey:@"authorName"];
        self.lastReply = [decoder decodeObjectForKey:@"lastReply"];
        self.buddyIconUrl = [decoder decodeObjectForKey:@"buddyIconUrl"];
    }
    return self;
}

@end
