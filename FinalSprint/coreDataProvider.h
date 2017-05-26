//
//  coreDataProvider.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/26/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Genre+CoreDataProperties.h"

@interface coreDataProvider : NSObject

+(NSArray *)getGenresFromIdsArray:(NSArray *)idsArray withContext:(NSManagedObjectContext *)context;

@end
