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

- (id) initWithPattern:(NSString *) pattern;
- (NSString *) generateUrlWithParameters:(NSArray *) parameters;

@end
 