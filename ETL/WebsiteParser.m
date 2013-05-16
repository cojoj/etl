//
//  WebsiteParser.m
//  ETL
//
//  Created by Mateusz Zajac on 15.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "WebsiteParser.h"

@interface WebsiteParser ()

@property (strong, nonatomic) NSString *websiteToParse;
@property (strong, nonatomic) NSRegularExpression *regEx;

@end

@implementation WebsiteParser

- (id) initWithWebsiteContent:(NSString *)website regularExpression:(NSRegularExpression *)regEx
{
    if (self = [super init])
    {
        [self setWebsiteToParse:website];
        [self setRegEx:regEx];
    }
    return self;
}

- (BOOL) parse
{
    
}

@end
