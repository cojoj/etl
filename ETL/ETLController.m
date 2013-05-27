//
//  ETLController.m
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLController.h"


@implementation ETLController

- (id) init
{
    if (self = [super init])
    {
        etlModel = [[ETLModel alloc] init];
        storage = [[FileStorage alloc] initWithMainDirectoryAtPath:@"/Users/mateusz/Desktop" name:@"ETL"];
    }
    return self;
}

-(void) downloadWebsitesContent
{
    // Init generator to generate URL to given market quoutes of companies on given letter
    UrlGenerator *generator = [[UrlGenerator alloc] initWithPattern:@"http://findata.co.nz/Markets/$1/$2.htm"];
    [generator generateUrlWithParameters:@[@"1", @"2"]];

    
    for( NSString *market in [ETLModel getArrayOfMarkets] )
    {
        for( NSString *letter in [ETLModel getArrayOfLetter] )
        {
            NSString *url= [generator generateUrlWithParameters:@[market, letter]];
            
            //Init WebsiteDownloader to download source codes of generated websites
//            WebsiteDownloader *downloader = [[WebsiteDownloader alloc] initWithURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding];
            NSLog(@"%@", url);
        }
    }
    
}

-(void) extractWebsitesContent
{
    NSString *websiteContent = [[NSString alloc] initWithContentsOfFile: @"ETL/sample.txt"];
    
//    NSLog( websiteContent );
    
    CompanyDataExtractor *extractor = [[CompanyDataExtractor alloc] init];
    
    NSArray *data = [extractor extractDataFromWebsiteContent:websiteContent];
    
    for( NSString* line in data )
    {
        NSLog( @"%@", line );
    }
                                 
}

-(void) saveParsedData
{
    NSLog( @"saveParsedData" );
}

-(void) fullCycle
{
    NSLog( @"fullCycle" );
}


@end
