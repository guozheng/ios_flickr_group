//
//  FlickrGroupClient.h
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface FlickrGroupClient : BDBOAuth1RequestOperationManager

+ (FlickrGroupClient *)instance;

- (void)saveAccessToken:(BDBOAuthToken *)accessToken;

- (void)removeAccessToken;

- (BDBOAuthToken *)getAccessToken;

- (void)saveUser:(User *)currentUser;

- (void)removeUser;

- (User *)getCurrentUser;

- (void)logout;

- (void)login;

#pragma mark client methods

- (AFHTTPRequestOperation *)currentUserWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)getUserInfoWithUserId:(NSString *)userId
                                          success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)getGroupsWithUserId:(NSString *)userId
                                          success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)searchGroupsWithKeyword:(NSString *)keyword
                                            success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)joinGroupWithGroupId:(NSString *)groupId
                                            success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)getGroupDetailWithGroupId:(NSString *)groupId
                                        success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

@end