//
//  Genre+CoreDataProperties.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/26/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Genre+CoreDataProperties.h"

@implementation Genre (CoreDataProperties)

+ (NSFetchRequest<Genre *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Genre"];
}

@dynamic genreID;
@dynamic movieGenre;
@dynamic name;
@dynamic tvGenre;
@dynamic movies;

@end
