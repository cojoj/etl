//
//  FileStorage.h
//  ETL
//
//  Created by Mateusz Zajac on 27.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Class which is responsible for creating directories for application files and
 * for saving data to files.
 */
@interface FileStorage : NSObject

/**
 * A NSString property with main directory where all application data will be stored
 */
@property (strong, nonatomic) NSString *mainDirectoryPath;

/**
 * Initializes main directory where application data will be stored
 */
- (id) initWithMainDirectoryAtPath:(NSString *)path name:(NSString *)name;

/**
 * Creates new directory in main directory (created in designated initializer) named after parameter
 */
- (void) createDirectoryInMainDirectoryNamed:(NSString *)name;

/**
 * Saves NSString content to specified file (with given extension) in directory given as a last parameter
 */
- (void) saveContent:(NSString *)content toFile:(NSString *)name withExtension:(NSString *)extension inDirectory:(NSString *)directory;

/**
 * Loads data from given path and checks if the given files exsists. If yes, than method returns NSString with content of this file
 */
- (NSString *) loadContentOfFile:(NSString *)filePath;

@end
