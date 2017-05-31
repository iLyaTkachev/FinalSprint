//
//  DetailViewController.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/22/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "DetailViewController.h"
#import "Movie+CoreDataProperties.h"
#import "Provider.h"
#import "Constants.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *objectTitle;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *rating;
@property (strong, nonatomic) IBOutlet UILabel *overview;
@property (strong, nonatomic) IBOutlet UILabel *genres;
@property (nonatomic,strong) Provider *provider;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"details is loaded");
    


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)addClick:(id)sender {
}

-(void)configureVCwithObject:(NSObject *)object withObjectType:(NSString *)type {
    
    self.provider = [[Provider alloc]init];
    if ([type isEqualToString:@"Movie"]) {
        self.objectTitle.text = [object valueForKey:@"title"];
        self.date.text = [object valueForKey:@"releaseDate"];
        self.rating.text = [NSString stringWithFormat:@"%.1f", [[object valueForKey:@"voteAverage"] floatValue]];
        self.overview.text = [object valueForKey:@"overview"];
        self.genres.text = [[[[object valueForKey:@"genres"] allObjects] valueForKey:@"name"] componentsJoinedByString:@", "];
        
        NSString *path=[NSString stringWithFormat: @"%@%@", movieBackImagesDB, [object valueForKey:@"backdropPath"]];
        [self.provider downloadImageWithoutSavingWithUrl:path withBlock:^(UIImage *img,NSError *error)
         {
             if (error==nil)
             {
                 @try {
                     self.backImage.image = img;
                 } @catch (NSException *exception) {
                     NSLog(@"Error in back image");
                 }
             }
             
             else{
                 NSLog(@"%@",error.description);
             }
         }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
