//
//  NSURLConnection+StubAdditions.m
//
//	Copyright (c) 2012 Overcommitted, LLC
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "NSURLConnection+StubAdditions.h"
#import "NSObject+MethodSwizzlingAdditions.h"

@implementation NSURLConnection (StubAdditions)
static NSURLRequest *gRequest = nil;
static NSURLResponse *gResponse = nil;
static NSData *gData = nil;
static NSError *gError = nil;

+ (void)mockSendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    gRequest = request;
    handler(gResponse, gData, gError);
}

+ (void)stubSendAsynchronousRequestAndExecuteCompletionHandlerWithResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error returningRequest:(NSURLRequest **)request whileExecutingBlock:(void (^)(void))block
{
    gRequest = nil;
    gResponse = response;
    gData = data;
    gError = error;
    
    [NSObject swizzleMethod:@selector(sendAsynchronousRequest:queue:completionHandler:)
                  inClass:[NSURLConnection class]
               withMethod:@selector(mockSendAsynchronousRequest:queue:completionHandler:)
                fromClass:[self class]
             executeBlock:block
     ];
    
    if (request) *request = gRequest;
}

+ (void)stubSendAsynchronousRequestAndExecuteCompletionHandlerWithData:(NSData *)data error:(NSError *)error returningRequest:(NSURLRequest **)request whileExecutingBlock:(void (^)(void))block
{
    [self stubSendAsynchronousRequestAndExecuteCompletionHandlerWithResponse:nil data:data error:error returningRequest:request whileExecutingBlock:block];
}

+ (void)stubSendAsynchronousRequestAndExecuteCompletionHandlerWithData:(NSData *)data returningRequest:(NSURLRequest **)request whileExecutingBlock:(void (^)(void))block
{
    [self stubSendAsynchronousRequestAndExecuteCompletionHandlerWithData:data error:nil returningRequest:request whileExecutingBlock:block];
}

+ (void)stubSendAsynchronousRequestAndExecuteCompletionHandlerWithDataFromDictionary:(NSDictionary *)dictionary returningRequest:(NSURLRequest **)request whileExecutingBlock:(void (^)(void))block
{
    [self stubSendAsynchronousRequestAndExecuteCompletionHandlerWithData:[NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil] error:nil returningRequest:request whileExecutingBlock:block];
}

+ (void)stubSendAsynchronousRequestAndReturnRequest:(NSURLRequest **)request whileExecutingBlock:(void (^)(void))block
{
    [self stubSendAsynchronousRequestAndExecuteCompletionHandlerWithData:nil returningRequest:request whileExecutingBlock:block];
}
@end
