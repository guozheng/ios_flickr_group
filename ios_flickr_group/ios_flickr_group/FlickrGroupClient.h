//
//  FlickrGroupClient.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface FlickrGroupClient : BDBOAuth1RequestOperationManager

+ (FlickrGroupClient *)instance;

- (void)saveAccessToken:(BDBOAuthToken *)accessToken;

- (void)removeAccessToken;

- (BDBOAuthToken *)getAccessToken;

- (void)saveUser:(NSDictionary *)currentUser;

- (void)removeUser;

- (NSDictionary *)getCurrentUser;

- (void)logout;

- (void)login;

- (AFHTTPRequestOperation *)getGroupsWithUserId:(int)userId
                                          success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

@end