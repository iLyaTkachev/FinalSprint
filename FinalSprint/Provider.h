//
//  Provider.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/15/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "JsonParser.h"

@interface Provider : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;

-(id)initWithContext:(NSManagedObjectContext *)context;
-(void)updateContextWithEntity:(NSEntityDescription *)entity withUrl:(NSString *)url withDeleting:(bool)mode withBlock: (void(^)(NSError *)) block;
-(void)downloadImageWithUrl:(NSString *)url withBlock:(void(^)(UIImage *,NSError *)) block;
-(void)downloadImageWithoutSavingWithUrl:(NSString *)url withBlock:(void(^)(UIImage *,NSError *)) block;
-(NSString *)getUrlPartFromGenres:(NSMutableDictionary *)selectedGenres;
-(NSDictionary *)getSortingDictionary;
-(NSDictionary *)getGenresDictionary;

@end
