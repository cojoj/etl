//
//  AppDelegate.h
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ETLController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    ETLController *etl;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)downloadAction:(id)sender;
- (IBAction)extractAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)fullCycleAction:(id)sender;
- (IBAction)showAction:(id)sender;
- (IBAction)updateMarketAction:(id)sender;
- (IBAction)restartETLAction:(id)sender;


@end
