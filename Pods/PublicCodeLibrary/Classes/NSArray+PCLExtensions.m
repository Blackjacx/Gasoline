//
//  NSArray+PCLExtensions.m
//  PublicCodeLibrary
//
//  Created by noskill on 23.05.11.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

#import "NSArray+PCLExtensions.h"

@implementation NSArray (PCLExtensions)

- (NSArray*)pcl_sortedWithKey:(NSString*)aKey ascending:(BOOL)sortAscending
{
    NSSortDescriptor * const aSortDescriptor = [[NSSortDescriptor alloc]
                                                    initWithKey:aKey 
                                                    ascending:sortAscending];
    
    NSArray * const sortDescriptorList = [[NSArray alloc] 
                                          initWithObjects:aSortDescriptor, nil];
    
    NSArray * const result = [self sortedArrayUsingDescriptors:sortDescriptorList];
    
    
    return result;
}

@end
