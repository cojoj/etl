//
//  FileStorage.h
//  ETL
//
//  Created by Mateusz Zajac on 27.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileStorage : NSObject

- (id) initWithMainDirectoryAtPath:(NSString *)path name:(NSString *)name;
- (void) createDirectoryInMainDirectoryNamed:(NSString *)name;
- (void) saveContent:(NSString *)content toFilename:(NSString *)name withExtension:(NSString *)extension inDirectory:(NSString *)directory;

@end
