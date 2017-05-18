//
//  URLConnection.h
//  FinalSprint
//
//  Created by iLya Tkachev on 5/15/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConnection : NSObject

- (void)downloadData:(NSURL *)url myBlock:(void(^)(NSData *,NSError *))myBlock;

@end
