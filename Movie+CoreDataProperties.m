//
//  Movie+CoreDataProperties.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/12/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Movie+CoreDataProperties.h"

@implementation Movie (CoreDataProperties)

+ (NSFetchRequest<Movie *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Movie"];
}

@dynamic title;
@dynamic posterPath;
@dynamic overview;
@dynamic releaseDate;
@dynamic movieID;
@dynamic backdropPath;
@dynamic popularity;
@dynamic voteCount;
@dynamic vote_average;
@dynamic actors;

@end
