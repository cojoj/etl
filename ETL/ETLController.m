//
//  ETLController.m
//  ETL
//
//  Created by Maciej Komorowski on 16.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "ETLController.h"
#import "AppDelegate.h"
#import "Company.h"

@implementation ETLController

//
// ETLController constructor
//
- (id) init
{
    if (self = [super init])
    {
        // Set start-up state
        currentState = (ETLState) nothingDoneYet;
    }
    return self;
}

//
// Download from http://findata.co.nz websites source
// with quotes and save it to both .txt file and ETL model container
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
            
            // Checking if file with web source is already saved in the directory 
            if ( ! [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
            {
                // Init WebsiteDownloader to download source codes of generated websites
                WebsiteDownloader *downloader = [[WebsiteDownloader alloc] initWithURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding];
                
                // Save web source first to variable then to file
                webSource = [downloader websiteSource];
                [[self getFileStorage] saveContent:webSource
                          toFile:filename
                       withExtension:TXT_EXTENSION
                         inDirectory:@"WebSources"];
            
                // Update progress bar
                double progressLevel =
                    ( [[[self getETLModel] downloadedWebsitesContainer] count] + 1 )
                    / websiteCount
                    * 100;
                [(AppDelegate *) [[NSApplication sharedApplication] delegate] updateProgressBarPanelWithProgressLevel:progressLevel];
            }
            // Else load content of file   
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
    
    // Create counter of companies
    NSInteger companiesCounter = 0;
    
    //Iterates through websites source container
    for ( NSString* key in [[self getETLModel] downloadedWebsitesContainer] )
    {        
        NSMutableArray *data;
        NSString *dataAsString;
        NSString *fullPath = [NSString stringWithFormat:@"%@/CSV/%@.%@", [storage mainDirectoryPath], key, CSV_EXTENSION];
        
        // Checking if CSV file with extraced data is already saved in the directory
        if ( ! [[NSFileManager defaultManager] fileExistsAtPath:fullPath] )
        {
            // Extract company data from the stored website content
            data = [extractor extractDataFromWebsiteContent:[[[self getETLModel] downloadedWebsitesContainer] objectForKey:key]];
            // Create string with each company data in new line
            dataAsString = [data componentsJoinedByString:@""]; // Note that last line of string is empty
            // Saving data to .csv file
            [[self getFileStorage] saveContent:dataAsString
                                        toFile:key
                                 withExtension:CSV_EXTENSION
                                   inDirectory:@"CSV"];
            
            // Update progress bar
            double progressLevel =
                ( [[[self getETLModel] extracedDataContainer] count] + 1 )
                / (double) [[[self getETLModel] downloadedWebsitesContainer] count]
                * 100;
            [(AppDelegate *) [[NSApplication sharedApplication] delegate] updateProgressBarPanelWithProgressLevel:progressLevel];
        }
        else
        {
            NSLog(@"Plik: %@, już istieje", fullPath);
            // Load content of CSV file
            dataAsString = [[self getFileStorage] loadContentOfFile:fullPath];
            // Split string by line
            data = [dataAsString componentsSeparatedByString:@"\r"];
            // Remove last line ( which is empty )
            [data removeLastObject];
        }
        
        // Increment companies counter
        companiesCounter += [data count];
        
        // Store data in etl container
        [[[self getETLModel] extracedDataContainer] setObject:data forKey:key];
    }
    
    // Set count of companies
    [[self getETLModel] setCompaniesCount:companiesCounter];
    
    // Hide progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] hideProgressBarPanel];
    
    // Disable GUI extract action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] extractButton] setEnabled:NO];
    
    //Change ETL state
    currentState = (ETLState) dataExtraced;
    
    NSLog( @"Action extractCompaniesData complete." );
}

//
// Save extraced data of companies to persistent store
//
-(void) saveExtractedData
{
    // Allow data to be saved only after ETL has extraced companies data from websites source
    if ( currentState != (ETLState) dataExtraced )
    {
        NSLog( @"Action not allowed with current ETL state." );
        return;
    }
        
    // Show progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] showProgressBarPanelWithTitle:@"Zapisywanie danych"];
    
    // Load managed object contex
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create iteration counter
    NSInteger interationCounter = 0;
        
    // Save each comapny data to persistent store
    for ( NSString* key in [[self getETLModel] extracedDataContainer] )
    {
        // Get companies data with key {MARKET}_{LETTER} from ETL container 
        NSArray *companiesData = [[[self getETLModel] extracedDataContainer] objectForKey:key];
        
        // Extract from key ( with pattern {MARKET}_{LETTER} ) market name
        // by spliting key by "_" and taking first object from compontents
        NSString *marketWithLetter = [[key componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *market = [marketWithLetter substringToIndex:[marketWithLetter length]-2];
                
        // Loop through each company
        for ( NSString *comapnyDataAsString in companiesData )
        {
            // Split string by ";" 
            NSArray *companyData = [comapnyDataAsString componentsSeparatedByString:@";"];
            
            // Create a new managed object
            NSManagedObject *newCompany = [NSEntityDescription insertNewObjectForEntityForName:@"Company"
                                                                        inManagedObjectContext:context];
            // Set values of new object
            [newCompany setValue:[companyData objectAtIndex:0] forKey:@"code"];
            [newCompany setValue:[companyData objectAtIndex:1] forKey:@"name"];
            [newCompany setValue:market forKey:@"market"];
            
            NSError *error = nil;
            
            // Save the object to persistent store
            if ( ! [context save:&error] ) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            
            // Update progress bar
            double progressLevel =
                ++interationCounter
                / (double) [[self getETLModel] companiesCount]
                * 100;
            
            [(AppDelegate *) [[NSApplication sharedApplication] delegate] updateProgressBarPanelWithProgressLevel:progressLevel];
        }
    }
    
    // Hide progress bar
    [(AppDelegate *) [[NSApplication sharedApplication] delegate] hideProgressBarPanel];
    
    // Disable GUI extract action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] saveButton] setEnabled:NO];
    // Disable GUI full cycle action button
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] fullCycleButton] setEnabled:NO];
    
    //Change ETL state
    currentState = (ETLState) dataSaved;
    
     NSLog( @"Action saveParsedData complete." );
}

//
// Run full cycle of ETL program
//
-(void) fullCycle
{
    [self downloadWebsitesSource];
    [self extractCompaniesData];
    [self saveExtractedData];
}

//
// Run full cycle of ETL program
//
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
    [self deleteAllObjectsFromCoreData];
    
    // Enable buttons
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] downloadButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] extractButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] saveButton] setEnabled:YES];
    [[(AppDelegate *) [[NSApplication sharedApplication] delegate] fullCycleButton] setEnabled:YES];
    
    // Change ETL state
    currentState = nothingDoneYet;
    
    NSLog( @"ETL was restarted." );

}

//
// Makes fetch request to the created SQLite database and displays 
//
- (NSArray *) makeFetchRequest
{
    // Create the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Entity whose contents we want to read
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    
    // We will sort the data by markets and by codes
    NSSortDescriptor *marketSort = [[NSSortDescriptor alloc] initWithKey:@"market" ascending:YES];
    NSSortDescriptor *codeSort = [[NSSortDescriptor alloc] initWithKey:@"code" ascending:YES];
    
    // Creating NSArray with sort descriptors
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:marketSort, codeSort, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Tellthe request that we want to read the contents of the Comapny entity
    [fetchRequest setEntity:entity];
    
    NSError *requestError = nil;
    
    // Executes the fetch request on the context
    NSArray *companies = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    return companies;
}

//
// Getter for FileStorage instance
//
-(FileStorage *) getFileStorage
{
    // If no file storge init it
    if( ! storage )
    {
        storage = [[FileStorage alloc] initWithMainDirectoryAtPath:NSHomeDirectory() name:@"ETL"];
    }
    
    return storage;
}

//
// Getter for ETLModel instance
//
-(ETLModel *) getETLModel
{
    // If no file storge init it
    if( ! etlModel )
    {
        etlModel = [[ETLModel alloc] init];
    }
    
    return etlModel;
}

- (void) deleteAllObjectsFromCoreData
{
    NSArray *objects = [NSArray arrayWithArray:[self makeFetchRequest]];
    
    for (NSManagedObject *managedObject in objects)
    {
        [[self managedObjectContext] deleteObject:managedObject];
    }
    
    NSError *error = nil;
    
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Error in savind CoreData after deletion");
    }
}

//
// Getter for managedObjectContext
//
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[NSApplication sharedApplication] delegate];
    
    // Get context from AppDelegate
    if ( [delegate performSelector:@selector(managedObjectContext)] )
    {
        context = [delegate managedObjectContext];
    }
    
    return context;
}


@end
