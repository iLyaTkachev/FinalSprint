//
//  Movie+CoreDataProperties.m
//  FinalSprint
//
//  Created by iLya Tkachev on 5/25/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Movie+CoreDataProperties.h"

@implementation Movie (CoreDataProperties)

+ (NSFetchRequest<Movie *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Movie"];
}

@dynamic backdropPath;
@dynamic movieID;
@dynamic overview;
@dynamic popularity;
@dynamic posterPath;
@dynamic releaseDate;
@dynamic runtime;
@dynamic title;
@dynamic voteAverage;
@dynamic voteCount;
@dynamic actors;
@dynamic genres;

@end
