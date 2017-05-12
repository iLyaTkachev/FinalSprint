//
//  HTTPCommunication.m
//  Sprint03
//
//  Created by iLya Tkachev on 4/16/17.
//  Copyright © 2017 iLya Tkachev. All rights reserved.
//

#import "HTTPCommunication.h"

@implementation HTTPCommunication

NSURLSession *session;

-(id) init
{
    self=[super init];
    if(self)
    {
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    }
    return self;
}
- (void)retrieveURL:(NSURL *)url myBlock:(void(^)(NSArray *))block
{
    self.myBlock = block;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    [task resume];
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSError *error = nil;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:&error];
    
    if (!error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.myBlock(dataArray);
        });
    }
}

@end
