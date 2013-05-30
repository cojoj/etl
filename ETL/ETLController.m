//
//  ETLController.m
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLController.h"
#import "AppDelegate.h"


@implementation ETLController

- (id) init
{
    if (self = [super init])
    {
        currentState = (ETLState) nothingDoneYet;
    }
    return self;
}

//
// Download from http://findata.co.nz websites source with quotes and save it to both .txt file and ETL model container
//
-(void) downloadWebsitesSource
{
    // Allow websites download only if ETL has done nothing so far
    if ( currentState != (ETLState) nothingDoneYet )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Count web sites to process
    double websiteCount = [[ETLModel getArrayOfMarkets] count] * [[ETLModel getArrayOfLetter] count];
            
    // Show progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] showProgressBarPanelWithTitle:@"Ściąganie stron"];
    
    // Init generator to generate URL to given market quoutes of companies on given letter
    UrlGenerator *generator = [[UrlGenerator alloc] initWithPattern:@"http://findata.co.nz/Markets/$1/$2.htm"];

    //Creates subdirectory with websources
    [[self getFileStorage] createDirectoryInMainDirectoryNamed:@"WebSources"];
    
    for( NSString *market in [ETLModel getArrayOfMarkets] )
    {
        for( NSString *letter in [ETLModel getArrayOfLetter] )
        {
            NSString *url= [generator generateUrlWithParameters:@[market, letter]];
            NSString *filename = [NSString stringWithFormat:@"%@_%@", market, letter];
            NSString *fullPath = [NSString stringWithFormat:@"%@/WebSources/%@.%@", [storage mainDirectoryPath], filename, TXT_EXTENSION];
            NSString *webSource;
            
            //Checking if file with web source is already saved in the directory 
            if ( ! [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
            {
                //Init WebsiteDownloader to download source codes of generated websites
                WebsiteDownloader *downloader = [[WebsiteDownloader alloc] initWithURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding];
                
                // Save web source first to variable then to file
                webSource = [downloader websiteSource];
                [[self getFileStorage] saveContent:webSource
                          toFile:filename
                       withExtension:TXT_EXTENSION
                         inDirectory:@"WebSources"];
            
                // Updated progress bar
                double progressLevel = ( [[[self getETLModel] downloadedWebsitesContainer] count] + 1 ) / websiteCount * 100;
                [(AppDelegate *) [[NSApplication sharedApplication] delegate] updateProgressBarPanelWithProgressLevel:progressLevel];
            }
            //If the are we are doing nothing - just logging the proper information
            else
            {
                NSLog(@"Plik: %@, już istieje", fullPath);
                webSource = [[self getFileStorage] loadContentOfFile:fullPath];
            }
            
            // Append web source to model container
            [[[self getETLModel] downloadedWebsitesContainer] setObject:webSource forKey:filename];

        }
    }
    
    // Hide progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] hideProgressBarPanel];
    
    // Disable GUI download action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] downloadButton] setEnabled:NO];
    
    //Change ETL state
    currentState = (ETLState) websitesDownloaded;
    
}
//
// Extract company data ( company name, symbol, quotes, company market value ) from previously downloaded web sources 
//
-(void) extractCompaniesData
{
    // Allow data extraction only after ETL has downloaded websites
    if ( currentState != (ETLState) websitesDownloaded )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Show progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] showProgressBarPanelWithTitle:@"Wyciąganie danych"];
    
    // Create CSV folder for CSVs
    [[self getFileStorage] createDirectoryInMainDirectoryNamed:@"CSV"];
    
    // Init extractor object
    CompanyDataExtractor *extractor = [[CompanyDataExtractor alloc] init];
    
    //Iterates through website container
    for ( NSString* key in [[self getETLModel] downloadedWebsitesContainer] )
    {
        NSString *data;
        NSString *fullPath = [NSString stringWithFormat:@"%@/CSV/%@.%@", [storage mainDirectoryPath], key, CSV_EXTENSION];
        
        // Checking if CSV file with extraced data is already saved in the directory
        if ( ! [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
        {
            // Extract company data from the stored website content
            NSArray *dataArray = [extractor extractDataFromWebsiteContent:[[[self getETLModel] downloadedWebsitesContainer] objectForKey:key]];
            data = [dataArray componentsJoinedByString:@""];
            // Saving data to .csv file
            [[self getFileStorage] saveContent:data toFile:key withExtension:CSV_EXTENSION inDirectory:@"CSV"];
            
            // Updated progress bar
            double progressLevel =
                ( [[[self getETLModel] extracedDataContainer] count] + 1 )
                / (double) [[[self getETLModel] downloadedWebsitesContainer] count]
                * 100;
            [(AppDelegate *) [[NSApplication sharedApplication] delegate] updateProgressBarPanelWithProgressLevel:progressLevel];
        }
        else
        {
            NSLog(@"Plik: %@, już istieje", fullPath);
            data = [[self getFileStorage] loadContentOfFile:fullPath];
        }
        // Store data in etl container
        [[[self getETLModel] extracedDataContainer] setObject:data forKey:key];
    }
    
    // Hide progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] hideProgressBarPanel];
    
    // Disable GUI extract action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] extractButton] setEnabled:NO];
    
    //Change ETL state
    currentState = (ETLState) dataExtraced;
    
}

-(void) saveExtractedData
{
    // Allow data to be saved only after ETL has extraced companies data from websites source
    if ( currentState != (ETLState) dataExtraced )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
    
    // Disable GUI extract action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] saveButton] setEnabled:NO];
    // Disable GUI full cycle action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] fullCycleButton] setEnabled:NO];
    
    NSLog( @"saveParsedData" );
    
    //Change ETL state
    currentState = (ETLState) dataSaved;
}

-(void) fullCycle
{
    [self downloadWebsitesSource];
    [self extractCompaniesData];
    [self saveExtractedData];
}

-(void) restart
{
    // Clear pointers to instance veriables
    storage = nil;
    etlModel = nil;
    
    // Change ETLState to default state of the application after run
    currentState = (ETLState) nothingDoneYet;
    
    // Delete created ETL folder with files
    [[NSFileManager defaultManager] removeItemAtPath:[[self getFileStorage] mainDirectoryPath] error:nil];
    
    // Delete data base records
    
    // Enable buttons
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] downloadButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] extractButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] saveButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] fullCycleButton] setEnabled:YES];
    
    // Change ETL state
    currentState = nothingDoneYet;
    
    NSLog( @"ETL został zrestartowany." );

}

-(FileStorage *) getFileStorage
{
    // If no file storge init it
    if( ! storage )
        storage = [[FileStorage alloc] initWithMainDirectoryAtPath:NSHomeDirectory() name:@"ETL"];
    
    return storage;
}

-(ETLModel *) getETLModel
{
    // If no file storge init it
    if( ! etlModel )
        etlModel = [[ETLModel alloc] init];
    
    return etlModel;
}


@end
