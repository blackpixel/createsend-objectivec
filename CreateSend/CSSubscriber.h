//
//  CSSubscriber.h
//  CreateSend
//
//  Copyright (c) 2012 Freshview Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSubscriber : NSObject
@property (copy) NSString *emailAddress;
@property (copy) NSString *name;
@property (strong) NSDate *date;
@property (copy) NSString *state;
@property (strong) NSArray *customFields;

+ (id)subscriberWithEmailAddress:(NSString *)emailAddress name:(NSString *)name customFields:(NSArray *)customFields;

+ (id)subscriberWithDictionary:(NSDictionary *)subscriberDictionary;

+ (NSDictionary *)dictionaryWithEmailAddress:(NSString *)emailAddress name:(NSString *)name customFieldValues:(NSArray *)customFieldValues;

- (id)initWithDictionary:(NSDictionary *)subscriberDictionary;

@end