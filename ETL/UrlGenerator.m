//
//  UrlGenerator.m
//  ETL
//
//  Created by Maciej Komorowski on 20.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "UrlGenerator.h"

@implementation UrlGenerator

//
// UrlGenerator constructor.
// Example URL pattern looks like http://example.com/$1/$2/
// where $1 and $2 are dynamic segments of URL.
//
- (id) initWithPattern:(NSString*) pattern
{
    if ( self = [super init] )
    {
        [self setPattern: pattern];
    }
    
    return self;
}

//
// Generate url by swaping dynamic segments ( ex. $1, $2 ... ) 
// of URL pattern with given parameters
//
- (NSString *) generateUrlWithParameters:(NSArray *) parameters;
{
    NSMutableString *url = [NSMutableString stringWithString:[self pattern]];
        
    for( int i = 1; i <= [parameters count]; i++ )
    {
        [url replaceOccurrencesOfString: [NSString stringWithFormat:@"$%i", i]
                             withString: [parameters objectAtIndex:i-1]
                                options: 0
                                  range: NSMakeRange(0, [url length])];
    }
    
    return url;
}

@end
