//
//  Provider.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/15/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Provider : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectContext *privateContext;
@property (nonatomic,strong) NSMutableDictionary *imageDict;

-(id)initWithContext:(NSManagedObjectContext *)context;
-(void)getObjectsFromURL:(NSString *)urlAdress withBlock: (void(^)(NSArray *, NSError *)) block;
-(void)downloadNewMoviesFromPage:(int)pageCount withDeleting:(bool)mode withBlock: (void(^)(NSError *)) block;
-(void)downloadImageWithUrl:(NSString *)url withBlock:(void(^)(UIImage *)) block;

@end
