//
//  PopViewController.h
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myPopviewProtocol <NSObject>

- (void)settingsChoosedWithResult:(NSMutableDictionary *)result;

@end

@interface PopViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *selectedGenreDictionary;
@property (nonatomic, weak) id <myPopviewProtocol> delegate;

@end
