//
//  JsonParser.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/24/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie+CoreDataClass.h"

@interface JsonParser : NSObject

-(void)newMovie:(Movie *)newObject from:(NSDictionary *)jsonObject withGenreDict:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context;
-(void)newGenre:(NSObject *)newObject from:(NSDictionary *)jsonObject;

@end
