//
//  Actor+CoreDataProperties.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/26/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Actor+CoreDataProperties.h"

@implementation Actor (CoreDataProperties)

+ (NSFetchRequest<Actor *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Actor"];
}

@dynamic id;
@dynamic name;
@dynamic profilePath;
@dynamic movies;

@end
