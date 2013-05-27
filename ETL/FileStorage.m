//
//  FileStorage.m
//  ETL
//
//  Created by Mateusz Zajac on 27.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "FileStorage.h"

@interface FileStorage ()
{
    BOOL isDir;
}

@property (strong, nonatomic) NSString *mainDirectoryPath;
@property (strong, nonatomic) NSFileManager *fileManager;

@end

@implementation FileStorage

- (id) initWithMainDirectoryAtPath:(NSString *)path name:(NSString *)name
{
    if (self = [super init])
    {
        self.mainDirectoryPath = [NSString stringWithFormat:@"%@/%@", path, name];
        self.fileManager = [NSFileManager defaultManager];
        
        //Checking if directory at given path exsits. If so than nothing happens but if not than we gonna greate it
        if (![self.fileManager fileExistsAtPath:self.mainDirectoryPath isDirectory:&isDir])
        {
            [self.fileManager createDirectoryAtPath:self.mainDirectoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    
    return self;
}

- (void) createDirectoryAtMainDirectoryPathNamed:(NSString *)name
{
    NSString *folderPath = [NSString stringWithFormat:@"%@/%@", self.mainDirectoryPath, name];
    
    if (![self.fileManager fileExistsAtPath:folderPath isDirectory:&isDir])
    {
        [self.fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

@end
