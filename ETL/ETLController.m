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
        storage = [[FileStorage alloc] initWithMainDirectoryAtPath:NSHomeDirectory() name:@"ETL"];
    }
    return self;
}

-(void) downloadWebsitesContent
{
    // Init generator to generate URL to given market quoutes of companies on given letter
    UrlGenerator *generator = [[UrlGenerator alloc] initWithPattern:@"http://findata.co.nz/Markets/$1/$2.htm"];
    [generator generateUrlWithParameters:@[@"1", @"2"]];

    //Creates subdirectory with websources
    [storage createDirectoryInMainDirectoryNamed:@"WebSources"];
    
    for( NSString *market in [ETLModel getArrayOfMarkets] )
    {
        for( NSString *letter in [ETLModel getArrayOfLetter] )
        {
            NSString *url= [generator generateUrlWithParameters:@[market, letter]];
            
            //Init WebsiteDownloader to download source codes of generated websites
            WebsiteDownloader *downloader = [[WebsiteDownloader alloc] initWithURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding];
            [storage saveContent:[downloader websiteSource]
                      toFilename:[NSString stringWithFormat:@"%@_%@", market, letter]
                   withExtension:@"txt"
                     inDirectory:@"WebSources"];
        }
    }
    
}

-(void) extractWebsitesContent
{
    [storage createDirectoryInMainDirectoryNamed:@"CSV"];
    CompanyDataExtractor *extractor = [[CompanyDataExtractor alloc] init];
    
    //Creates an NSArray of filenames created from downloaded websources
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", [storage mainDirectoryPath], @"WebSources"]
                                                                         error:NULL];
    
    //Iterates through files
    for (NSString *webSource in files)
    {
        //Variable with websource from file
        NSString *websiteContent = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@", [storage mainDirectoryPath], @"WebSources", webSource]
                                                             encoding:NSUTF8StringEncoding
                                                                error:NULL];
        //Creating filename 
        NSString *filename = [NSString stringWithFormat:@"%@", [webSource stringByDeletingPathExtension]];
        //Extracting RegularExprsssion from the websiteContent
        NSArray *data = [extractor extractDataFromWebsiteContent:websiteContent];
        
        //Saving data to .csv filename
        [storage saveContent:[data componentsJoinedByString:@"\n"] toFilename:filename withExtension:@"csv" inDirectory:@"CSV"];
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
