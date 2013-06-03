//
//  ETLModel.h
//  ETL
//
//  Created by Mateusz Zajac on 23.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETLModel : NSObject

/**
 * Container for downloaded websites source
 */
@property (strong, nonatomic)NSMutableDictionary *downloadedWebsitesContainer;

/**
 * Container for extracted data source
 */
@property (strong, nonatomic)NSMutableDictionary *extracedDataContainer;
@property (assign)NSInteger companiesCount;

/**
 * ETLModle constructor. Inits containers for data.
 */
- (id) init;

/**
 * Return range of letters to be covered by ETL
 */
+ (NSArray *) getArrayOfLetter;

/**
 * Return names of markets to be covered by ETL
 */
+ (NSArray *) getArrayOfMarkets;

@end
