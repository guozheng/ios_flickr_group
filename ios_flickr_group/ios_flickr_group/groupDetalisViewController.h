//
//  groupDetalisViewController.h
//  ios_flickr_group
//
//  Created by Ashwini Satyanarayana on 7/18/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupDetalisViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

-(id)initWithGroupId:(NSString*)groupId;

@end
