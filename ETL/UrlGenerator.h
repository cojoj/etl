//
//  UrlGenerator.h
//  ETL
//
//  Created by Maciej Komorowski on 20.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlGenerator : NSObject

@property (strong, atomic) NSString* pattern;

/**
 * UrlGenerator constructor.
 * Example URL pattern looks like http://example.com/$1/$2/
 * where $1 and $2 are dynamic segments of URL.
 */
- (id) initWithPattern:(NSString *) pattern;

/**
 * Generate url by swaping dynamic segments ( ex. $1, $2 ... )
 * of URL pattern with given parameters
 */
- (NSString *) generateUrlWithParameters:(NSArray *) parameters;

@end
 