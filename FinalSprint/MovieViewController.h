//
//  MovieViewController.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/9/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopViewController.h"

@interface MovieViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UIPopoverPresentationControllerDelegate,myPopviewProtocol>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
