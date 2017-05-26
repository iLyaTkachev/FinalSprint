//
//  Actor+CoreDataProperties.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/26/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Actor+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Actor (CoreDataProperties)

+ (NSFetchRequest<Actor *> *)fetchRequest;

@property (nonatomic) int32_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *profilePath;
@property (nullable, nonatomic, retain) NSSet<Movie *> *movies;

@end

@interface Actor (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet<Movie *> *)values;
- (void)removeMovies:(NSSet<Movie *> *)values;

@end

NS_ASSUME_NONNULL_END
