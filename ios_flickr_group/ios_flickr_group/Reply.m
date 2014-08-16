//
//  Reply.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 8/16/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Reply.h"

@implementation Reply

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, message=%@, authorId=%@, authorName=%@, buddyIconUrl=%@, dateCreate=%d", self.id, self.message, self.authorId, self.authorName, self.buddyIconUrl, self.dateCreate];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:self.authorId forKey:@"authorId"];
    [encoder encodeObject:self.authorName forKey:@"authorName"];
    [encoder encodeObject:self.buddyIconUrl forKey:@"buddyIconUrl"];
    [encoder encodeInt:self.dateCreate forKey:@"dateCreate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.authorId = [decoder decodeObjectForKey:@"authorId"];
        self.authorName = [decoder decodeObjectForKey:@"authorName"];
        self.buddyIconUrl = [decoder decodeObjectForKey:@"buddyIconUrl"];
        self.dateCreate = [decoder decodeIntForKey:@"dateCreate"];
    }
    return self;
}

@end
