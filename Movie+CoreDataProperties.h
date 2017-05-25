//
//  Movie+CoreDataProperties.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/25/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Movie+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

+ (NSFetchRequest<Movie *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *backdropPath;
@property (nonatomic) int64_t movieID;
@property (nullable, nonatomic, copy) NSString *overview;
@property (nonatomic) float popularity;
@property (nullable, nonatomic, copy) NSString *posterPath;
@property (nullable, nonatomic, copy) NSString *releaseDate;
@property (nullable, nonatomic, copy) NSNumber *runtime;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) float voteAverage;
@property (nonatomic) int32_t voteCount;
@property (nullable, nonatomic, retain) NSSet<Actor *> *actors;
@property (nullable, nonatomic, retain) Genre *genres;

@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet<Actor *> *)values;
- (void)removeActors:(NSSet<Actor *> *)values;

@end

NS_ASSUME_NONNULL_END
