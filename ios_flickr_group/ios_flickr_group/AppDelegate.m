//
//  AppDelegate.m
//  ios_flickr_group
//
//  Created by Li Li on 7/17/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "AppDelegate.h"
#import "logInViewController.h"
#import "myGroupsViewController.h"
#import "NSURL+dictionaryFromQueryString.h"
#import "FlickrGroupClient.h"
#import "User.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // get white color for text on status bar
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = self.currentVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"url.scheme=%@, url.host=%@", url.scheme, url.host);
    
    if ([url.scheme isEqualToString:@"cpflickr"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            NSLog(@"parameters from callback: %@", parameters);
            
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                
                FlickrGroupClient *client = [FlickrGroupClient instance];
                [client fetchAccessTokenWithPath:@"/services/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"successfully fetched access token: %@", accessToken.token);
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    // save access token
                    [client saveAccessToken:accessToken];
                    NSLog(@"successfully saved access token");
                    
                    // get current user id
                    [client currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"successfully got current user id, response: %@", responseObject);
                        
                        NSString *userId = responseObject[@"user"][@"id"];
                        NSLog(@"userId: %@", userId);
                        
                        // get current user detailed info
                        [client getUserInfoWithUserId:userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSLog(@"successfully got current user detailed info, response: %@", responseObject);
                            
                            NSDictionary *person = responseObject[@"person"];
                            NSLog(@"person: %@", person);
                            
                            User *currentUser = [[User alloc] init];
                            currentUser.id = userId;
                            currentUser.username = person[@"username"][@"_content"];
                            currentUser.realname = person[@"realname"][@"_content"];
                            currentUser.buddyIconUrl = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", person[@"iconfarm"], person[@"iconserver"], userId];
                            
                            NSLog(@"created current user object: %@", currentUser);
                            
                            // create and save current user
                            [client saveUser:currentUser];
                            NSLog(@"successfully saved current user");
                            
                            // update root view controller based on whether or not the access token is saved
                            [self updateRootVC];
                            NSLog(@"successfully updated root vc");
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"failed to get current user info and save current user: %@", error);
                            NSLog(@"operation: %@", operation);
                        }];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"failed to fetch current user id: %@", error);
                        NSLog(@"operation: %@", operation);
                    }];
                    
                }failure:^(NSError *error) {
                    NSLog(@"failed to fetch access token: %@", error);
                    
                }];
            }
        }
        
        return YES;
        
    } else {
        NSLog(@"unsupported URL: %@", url);
    }
    
    return NO;
}

- (UIViewController *)currentVC {
    BDBOAuthToken *accessToken = [[FlickrGroupClient instance] getAccessToken];
    
    if (accessToken) {
        NSLog(@"found existing access token, showing my groups view");
        return self.myGroupsNVC;
    } else {
        NSLog(@"cound not find existing access token, login first");
        return self.loginVC;
    }
}

- (UINavigationController *)myGroupsNVC {
    if (!_myGroupsNVC) {
        myGroupsViewController *myGroupsVC = [[myGroupsViewController alloc] init];
        _myGroupsNVC = [[UINavigationController alloc] initWithRootViewController:myGroupsVC];
    }
    
    return _myGroupsNVC;
}

- (logInViewController *)loginVC {
    if (!_loginVC) {
        _loginVC = [[logInViewController alloc] init];
    }
    
    return _loginVC;
}

- (void)updateRootVC {
    self.window.rootViewController = self.currentVC;
}

@end
