//
//  Actor+CoreDataProperties.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/12/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "Actor+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Actor (CoreDataProperties)

+ (NSFetchRequest<Actor *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t id;
@property (nullable, nonatomic, copy) NSString *profilePath;

@end

NS_ASSUME_NONNULL_END
