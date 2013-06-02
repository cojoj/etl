//
//  AppDelegate.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Init market list
    [[self marketListPopUp] removeAllItems];
    [[self marketListPopUp] addItemsWithTitles:[ETLModel getArrayOfMarkets]];
    
    // Init ETL controller
    etl = [[ETLController alloc] init];
    
}

#pragma mark - ETL actions ( triggered by button click )

//
// Run in new thread ETLController::downloadWebsitesSource
//
- (IBAction)downloadAction:(id)sender
{
    [etl performSelectorInBackground:@selector(downloadWebsitesSource) withObject:nil];
}

//
// Run in new thread ETLController::extractCompaniesData
//
- (IBAction)extractAction:(id)sender
{
    [etl performSelectorInBackground:@selector(extractCompaniesData) withObject:nil];
}

//
// Run in new thread ETLController::saveExtractedData
//
- (IBAction)saveAction:(id)sender
{
    [etl performSelectorInBackground:@selector(saveExtractedData) withObject:nil];
}

//
// Run in new thread ETLController::fullCycle
//
- (IBAction)fullCycleAction:(id)sender
{
    [etl performSelectorInBackground:@selector(fullCycle) withObject:nil];
}

//
// Run in new thread ETLController::restart
//
- (IBAction)restartETLAction:(id)sender
{
    [etl performSelectorInBackground:@selector(restart) withObject:nil];
}

//
// Runs in new thread ETLController::restart
//
- (IBAction)showAction:(id)sender
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
    
    // Checks if we get an array of companies
    if ([companies count] > 0) {
        // Go through the companies in array one by one
        
        for (Company *company in companies) {
            NSLog(@"%@, %@, %@", company.market, company.code, company.name);
        }
    }
}


#pragma mark - Progress Bar

- (void) showProgressBarPanelWithTitle:(NSString *) title
{
    [[self panel] setTitle:title];
    [[self panel] makeKeyAndOrderFront:self];
}

- (void) updateProgressBarPanelWithProgressLevel:(double) progressLevel
{
    [[self progressBar] setDoubleValue:progressLevel];
    [[self progressBar] startAnimation:self];
}

- (void) hideProgressBarPanel
{
    [[self panel]  orderOut:self];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ETL" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ETL.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
