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

    - (NSString *) generateUrlWithParameters:(NSDictionary *) parameters;
    {
        return [self pattern];
    }

@end
