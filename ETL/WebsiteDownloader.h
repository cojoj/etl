//
//  WebsiteDownloader.h
//  ETL
//
//  Created by Maciej Komorowski on 14.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class is responsible for downlodaing a specified data from URL
 */
@interface WebsiteDownloader : NSObject

/**
 * Keep source of downloaded website 
 */
@property (strong, nonatomic) NSString *websiteSource;

/**
 * Designeted initializer for class which downloads web source from given URL with encoding (default is UTF8).
 */
- (id)initWithURL:(NSURL *)url encoding:(NSStringEncoding)encoding;

@end
