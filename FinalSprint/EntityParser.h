//
//  EntityParser.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/24/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityParser : NSObject

-(void)newMovie:(NSObject *)newObject from:(NSDictionary *)jsonObject;

@end
