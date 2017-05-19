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

-(id)initWithContext:(NSManagedObjectContext *)context;
-(void)getObjectsFromURL:(NSString *)urlAdress;
-(void)downloadNewMoviesFromPage:(int)page;

@end
