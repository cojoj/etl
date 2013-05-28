//
//  AppDelegate.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "AppDelegate.h"
#import "WebsiteDownloader.h"

#define NYSE @"http://www.findata.co.nz/Markets/NYSE.htm"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Init market list
    [[self marketListPopUp] removeAllItems];
    [[self marketListPopUp] addItemsWithTitles:[ETLModel getArrayOfMarkets]];
    
    // Init ETL controller
    etl = [[ETLController alloc] init];

}

- (IBAction)downloadAction:(id)sender
{
    [etl performSelectorInBackground:@selector(downloadWebsitesContent) withObject:nil];
}

- (IBAction)extractAction:(id)sender
{
    [etl performSelectorInBackground:@selector(extractCompanyData) withObject:nil];
}

- (IBAction)saveAction:(id)sender
{
    [etl performSelectorInBackground:@selector(saveExtracedData) withObject:nil];
}

- (IBAction)fullCycleAction:(id)sender
{
    [etl performSelectorInBackground:@selector(fullCycle) withObject:nil];
}



- (IBAction)showAction:(id)sender
{
    [[self panel] display];
    NSLog( @"Show action" );
}

- (IBAction)restartETLAction:(id)sender
{
    [etl restart];
<<<<<<< HEAD
    NSLog( @"Restart action" );
=======
>>>>>>> f97dceaffea9a5d21155b099ceacc0ebd40a7d9e
}

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

@end
