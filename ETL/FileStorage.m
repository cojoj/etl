//
//  fileStorage.m
//  ETL
//
//  Created by Mateusz Zajac on 27.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import "fileStorage.h"

@interface fileStorage ()

@property (strong, nonatomic) NSString *mainFolderPath;

@end

@implementation fileStorage

- (id) initWithPath:(NSString *)path
{
    if (self = [super init])
    {
        self.mainFolderPath = path;
    }
    
    return self;
}

@end
