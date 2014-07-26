//
//  FlickrGroupClient.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "FlickrGroupClient.h"
#import "User.h"

#define OAUTH_BASE_URL @"https://api.flickr.com/services/"
//#define OAUTH_BASE_URL @"https://www.flickr.com/services/"
#define API_BASE_URL @"https://api.flickr.com/services/api/"
#define KEY @"be0dd823b190c7219088ca71c318f640"
#define SECRET @"d372f98e6acc9df8"

@implementation FlickrGroupClient

static NSString * const kAccessToken = @"kAccessToken";
static NSString * const kCurrentUser = @"kCurrentUser";

+ (FlickrGroupClient *)instance {
    static FlickrGroupClient *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance)
    {
        return sharedInstance;
    }
    
    dispatch_once(&pred, ^{
        sharedInstance = [[FlickrGroupClient alloc] initWithBaseURL:[NSURL URLWithString:OAUTH_BASE_URL] consumerKey:KEY consumerSecret:SECRET];
    });
    
    sharedInstance.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    return sharedInstance;
}

- (void)saveAccessToken:(BDBOAuthToken *)accessToken {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAccessToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BDBOAuthToken *)getAccessToken {
    BDBOAuthToken *accessToken = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kAccessToken];
    if (data) {
        accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return accessToken;
}

- (void)removeUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveUser:(User *)currentUser {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:kCurrentUser];
    [defaults synchronize];
}

- (User *)getCurrentUser {
    User *currentUser = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults dataForKey:kCurrentUser];
    if (data) {
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return currentUser;
}

- (void)logout {
    [self deauthorize];
    [self removeAccessToken];
}

- (void)login {
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"cpflickr://oauth"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken){
                                NSLog(@"Got the request token: %@", requestToken.token);
                                NSString *authURL = [NSString stringWithFormat:@"%@oauth/authorize?oauth_token=%@&perms=write",
                                                     [NSURL URLWithString:OAUTH_BASE_URL],
                                                     requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                                NSLog(@"Opened the auth url");
                                
                            } failure:^(NSError *error) {
                                NSLog(@"Failed to get the request token: %@", error);
                            }];
}

/*
 * Use icon farm, icon server and id to construct buddy icon url. When both farm
 * and server are 0, no icon was uploaded for the user or group yet, use a default
 * buddy icon instead. We found there are 11 default buddy icons, randomly pick one
 * the format is: https://s.yimg.com/pw/images/buddyiconXY.png, XY is 01 to 11.
 */
- (NSString *)getBuddyIconUrlWithFarm:(NSString *)farm server:(NSString *)server id:(NSString *)id {
    NSLog(@"constructing buddy icon url, farm=%@, server=%@", farm, server);
    NSString *url = nil;
    if (farm.intValue == 0 && server.intValue == 0) {
        // use a default buddy icon
        NSUInteger r = arc4random_uniform(11) + 1; // random int between 1 to 11
        if (r < 10) {
            url = [NSString stringWithFormat:@"https://s.yimg.com/pw/images/buddyicon0%d.png", r];
        } else {
            url = [NSString stringWithFormat:@"https://s.yimg.com/pw/images/buddyicon%d.png", r];
        }
    } else {
        // construct a buddy icon
        url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", farm, server, id];
    }
    return url;
}

// get current user after passing auth, response includes user id and username
- (AFHTTPRequestOperation *)currentUserWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *url = @"rest";
    NSDictionary *params = @{@"method":@"flickr.test.login", @"format":@"json", @"nojsoncallback":@"1", @"api_key":KEY};
    NSLog(@"REST call for flickr.test.login");
    
    return [self GET:url parameters:params success:success failure:failure];
}

// get detailed user info
- (AFHTTPRequestOperation *)getUserInfoWithUserId:(NSString *)userId
                                          success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *url = @"rest";
    NSDictionary *params = @{@"method":@"flickr.people.getInfo", @"format":@"json", @"nojsoncallback":@"1", @"api_key":KEY, @"user_id":userId};
    NSLog(@"REST call for flickr.people.getInfo");

    return [self GET:url parameters:params success:success failure:failure];
}

// get group with user id
- (AFHTTPRequestOperation *)getGroupsWithUserId:(NSString *)userId
                                        success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *url = @"rest";
    NSDictionary *params = @{@"method":@"flickr.people.getGroups", @"format":@"json", @"nojsoncallback":@"1", @"api_key":KEY, @"user_id":userId};
    NSLog(@"REST call for flickr.people.getGroup");
    
    return [self GET:url parameters:params success:success failure:failure];
}

// search for groups by keywords
- (AFHTTPRequestOperation *)searchGroupsWithKeyword:(NSString *)keyword
                                        success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *url = @"rest";
    NSDictionary *params = @{@"method":@"flickr.groups.search", @"format":@"json", @"nojsoncallback":@"1", @"api_key":KEY, @"text":keyword};
    NSLog(@"REST call for flickr.groups.search");
    
    return [self GET:url parameters:params success:success failure:failure];
}


// join group
- (AFHTTPRequestOperation *)joinGroupWithGroupId:(NSString *)groupId
                                            success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *url = @"rest";
    NSDictionary *params = @{@"method":@"flickr.groups.join", @"format":@"json", @"nojsoncallback":@"1", @"api_key":KEY, @"group_id":groupId};
    NSLog(@"REST call for flickr.groups.join");
    
    return [self POST:url parameters:params success:success failure:failure];
}

// get group info
- (AFHTTPRequestOperation *)getGroupDetailWithGroupId:(NSString *)groupId
                                            success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *url = @"rest";
    NSDictionary *params = @{@"method":@"flickr.groups.getInfo", @"format":@"json", @"nojsoncallback":@"1", @"api_key":KEY, @"group_id":groupId};
    NSLog(@"REST call for flickr.groups.getInfo");
    
    return [self GET:url parameters:params success:success failure:failure];
}

// get group topics
- (AFHTTPRequestOperation *)getGroupTopicsWithGroupId:(NSString *)groupId
                                              success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *url = @"rest";
    NSDictionary *params = @{@"method":@"flickr.groups.discuss.topics.getList", @"format":@"json", @"nojsoncallback":@"1", @"api_key":KEY, @"group_id":groupId};
    NSLog(@"REST call for flickr.groups.discuss.topics.getList");
    
    return [self GET:url parameters:params success:success failure:failure];
}

@end
