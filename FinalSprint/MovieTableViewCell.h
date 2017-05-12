//
//  MovieTableViewCell.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/12/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *posterImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *genre;
@property (strong, nonatomic) IBOutlet UILabel *rating;

@end
