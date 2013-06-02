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

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (IBAction)downloadAction:(id)sender;
- (IBAction)extractAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)fullCycleAction:(id)sender;
- (IBAction)showAction:(id)sender;
- (IBAction)restartETLAction:(id)sender;

- (void) showProgressBarPanelWithTitle:(NSString *) title;
- (void) updateProgressBarPanelWithProgressLevel:(double) level;
- (void) hideProgressBarPanel;

@end
