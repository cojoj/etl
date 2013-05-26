//
//  AppDelegate.m
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "AppDelegate.h"

#define NYSE @"http://www.findata.co.nz/Markets/NYSE.htm"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Init ETL controller
    etl = [[ETLController alloc] init];
}

- (IBAction)downloadAction:(id)sender
{
    [etl downloadWebsitesContent];
}

- (IBAction)extractAction:(id)sender
{
    [etl extractWebsitesContent];
}

- (IBAction)fullCycleAction:(id)sender
{
    [etl fullCycle];
}

- (IBAction)saveAction:(id)sender
{
    [etl saveParsedData];
//    NSError *error = nil;
//    
//    if (![[self managedObjectContext] commitEditing]) {
//        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
//    }
//    
//    if (![[self managedObjectContext] save:&error]) {
//        [[NSApplication sharedApplication] presentError:error];
//    }
}

- (IBAction)showAction:(id)sender
{
    NSLog( @"Show action" );
}

- (IBAction)updateMarketAction:(id)sender
{
    NSLog( @"Update market action" );
}

- (IBAction)restartETLAction:(id)sender
{
    NSLog( @"Restart action" );
}

@end
