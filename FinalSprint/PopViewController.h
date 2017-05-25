//
//  PopViewController.h
//  Popovers
//
//  Created by Jay Versluis on 17/10/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *selectedGenre;
@property(nonatomic, copy) void(^myBlock)();

-(id)initWithArray:(NSArray *)array withBlock:(void(^)()) block;

@end
