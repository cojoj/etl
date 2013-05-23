//
//  QuotesScrapper.m
//  ETL
//
//  Created by Maciej Komorowski on 22.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "CompanyDataExtractor.h"

@implementation CompanyDataExtractor

-(id) init
{
    if ( self = [super init] )
    {
                
        regexTable = [NSRegularExpression regularExpressionWithPattern:@".*<table class=\"quotes\">(.*)</table>.*"
                                                  options: NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                                    error:nil];
        
        regexQuotes = [NSRegularExpression regularExpressionWithPattern:@".*<A [^>]*>([^<]*)</A>.*<td>([^<]*)</td><td[^>]*>([^<]*)</td><td[^>]*>([^<]*)</td><td[^>]*>([^<]*)</td><td[^>]*>([^<]*)</td>.*"
                                                               options: 0
                                                                 error:nil];

        
        
    }
    return self;
}

-(NSArray *) extractDataFromWebsiteContent:(NSString *) websiteContent
{
    // Init container for
    NSMutableArray* quotes = [[NSMutableArray alloc] init];
        
    NSString *tableContents = [regexTable stringByReplacingMatchesInString: websiteContent
                                                                   options:0
                                                                     range:NSMakeRange( 0, [websiteContent length] )
                                                              withTemplate: @"$1"];
    
    for ( NSString *line in [tableContents componentsSeparatedByString:@"\n"] )
    {
        // Match company symbol, company name, quoutes and company value.
        // Also add "?" sign to proper matches
        NSString *quoteOrHtml = [regexQuotes stringByReplacingMatchesInString: line
                                                                      options:0
                                                                        range:NSMakeRange(0, [line length])
                                                                 withTemplate: @"?$1;$2;$3;$4;$5;$6"];
        
        if ( [quoteOrHtml length] && [[quoteOrHtml substringToIndex: 1] isEqual: @"?"] )
        {
            NSString *quote = [quoteOrHtml substringFromIndex: 1];
            [quotes addObject: quote];
        }
    }
    
    return quotes;
}

@end
