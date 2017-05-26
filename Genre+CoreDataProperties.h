//
//  Genre+CoreDataProperties.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/26/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Genre+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Genre (CoreDataProperties)

+ (NSFetchRequest<Genre *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *genreID;
@property (nullable, nonatomic, copy) NSNumber *movieGenre;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *tvGenre;
@property (nullable, nonatomic, retain) NSSet<Movie *> *movies;

@end

@interface Genre (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet<Movie *> *)values;
- (void)removeMovies:(NSSet<Movie *> *)values;

@end

NS_ASSUME_NONNULL_END
