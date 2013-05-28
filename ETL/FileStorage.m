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

- (void) createDirectoryInMainDirectoryNamed:(NSString *)name
{
    NSString *dirPath = [NSString stringWithFormat:@"%@/%@", self.mainDirectoryPath, name];
    
    //Checking if directory at given path exsits. If so than nothing happens but if not than we gonna greate it
    if (![self.fileManager fileExistsAtPath:dirPath isDirectory:&isDir])
    {
        [self.fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

- (void) saveContent:(NSString *)content toFilename:(NSString *)name withExtension:(NSString *)extension inDirectory:(NSString *)directory
{
    //Creating path with filename and extension where the content should be saved
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@.%@", self.mainDirectoryPath, directory, name, extension];
    
    if (![self.fileManager fileExistsAtPath:filePath])
    {
        //Save content to file
        if ([content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL])
        {
            NSLog(@"Zapisano do: %@", filePath);

        } else
        {
            NSLog(@"Zapis do pliku się nie powiódł");
        }
    }

}

@end
