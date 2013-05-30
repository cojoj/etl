//
//  FileStorage.h
//  ETL
//
//  Created by Mateusz Zajac on 27.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileStorage : NSObject

@property (strong, nonatomic) NSString *mainDirectoryPath;


- (id) initWithMainDirectoryAtPath:(NSString *)path name:(NSString *)name;
- (void) createDirectoryInMainDirectoryNamed:(NSString *)name;
- (void) saveContent:(NSString *)content toFile:(NSString *)name withExtension:(NSString *)extension inDirectory:(NSString *)directory;
- (NSString *) loadContentOfFile:(NSString *)filePath;

@end
