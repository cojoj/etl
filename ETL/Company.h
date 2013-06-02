//
//  Company.h
//  ETL
//
//  Created by Mateusz Zajac on 28.05.2013.
//  Copyright (c) 2013 Maciej Komorowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * market;
@property (nonatomic, retain) NSString * name;

@end
