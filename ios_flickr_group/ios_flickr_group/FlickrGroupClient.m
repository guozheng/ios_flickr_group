//
//  FlickrGroupClient.m
//  ios_flickr_group
//
//  Created by Guozheng Ge on 7/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "FlickrGroupClient.h"

#define BASE_URL [NSURL URLWithString:@"https://api.flickr.com/services/rest/"]
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
        sharedInstance = [[FlickrGroupClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL] consumerKey:KEY consumerSecret:SECRET];
    });
    
    return sharedInstance;
}

- (void)saveAccessToken:(BDBOAuthToken *)accessToken {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAccessToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BDBOAuthToken *)getAccessToken
{
    BDBOAuthToken *accessToken = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kAccessToken];
    if (data) {
        accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return accessToken;
}

- (void)saveUser:(NSDictionary *)currentUser
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeUser
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)getCurrentUser
{
    NSDictionary *currentUser = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kCurrentUser];
    if (data) {
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return currentUser;
}

- (void)logout
{
    [self deauthorize];
    [self removeAccessToken];
}

- (void)login
{
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"cptwitter://oauth"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken){
                                NSLog(@"Got the request token");
                                NSString *authURL = [NSString stringWithFormat:@"%@oauth/authorize?oauth_token=%@",
                                                     BASE_URL,
                                                     requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                                NSLog(@"Opened the auth url");
                                
                            } failure:^(NSError *error) {
                                NSLog(@"Failed to get the request token");
                            }];
}


@end
