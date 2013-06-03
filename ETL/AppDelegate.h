//
//  AppDelegate.h
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ETLController.h"
#import "ETLModel.h"
#import "WebsiteDownloader.h"
#import "Company.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    ETLController *etl;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSPanel *panel;
@property (assign) IBOutlet NSPopUpButton* marketListPopUp;
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (assign) IBOutlet NSButton *downloadButton;
@property (assign) IBOutlet NSButton *extractButton;
@property (assign) IBOutlet NSButton *saveButton;
@property (assign) IBOutlet NSButton *fullCycleButton;
@property (weak) IBOutlet NSArrayController *databaseArrayController;
@property (weak) IBOutlet NSTableView *coreDataTableView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 * Run in new thread ETLController::downloadWebsitesSource
 */
- (IBAction)downloadAction:(id)sender;

/**
 * Run in new thread ETLController::extractCompaniesData
 */
- (IBAction)extractAction:(id)sender;

/**
 * Run in new thread ETLController::saveExtractedData
 */
- (IBAction)saveAction:(id)sender;

/**
 * Run in new thread ETLController::fullCycle
 */
- (IBAction)fullCycleAction:(id)sender;

/**
 * Shows data in table returend from ETLController::makeFetchRequest
 */
- (IBAction)showAction:(id)sender;

/**
 * Run in new thread ETLController::restart
 */
- (IBAction)restartETLAction:(id)sender;

/**
 * Show panel with progress bar
 */
- (void) showProgressBarPanelWithTitle:(NSString *) title;

/**
 * Upade progress bar level
 */
- (void) updateProgressBarPanelWithProgressLevel:(double) level;

/**
 * Hide panel with progress bar
 */
- (void) hideProgressBarPanel;

/**
 * Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory;

@end
