//
//  UrlGenerator.m
//  ETL
//
//  Created by Maciej Komorowski on 20.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "UrlGenerator.h"

@implementation UrlGenerator

    - (id) initWithPattern:(NSString*) pattern
    {
        if ( self = [super init] )
        {
            [self setPattern: pattern];
        }
        return self;
    }

    - (NSString *) generateUrlWithParameters:(NSArray *) parameters;
    {
        NSMutableString *url = [NSMutableString stringWithString:[self pattern]];
        
        for( NSUInteger i = 1; i <= [parameters count]; i++ )
        {
            [url replaceOccurrencesOfString: [NSString stringWithFormat:@"$%i", i]
                                 withString: [parameters objectAtIndex:i-1]
                                    options: 0
                                      range: NSMakeRange(0, [url length])];
        }
        
        return url;
    }

@end
