//
// VTDCoreDataStore.m
//
// Copyright (c) 2014 Mutual Mobile (http://www.mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VTDCoreDataStore.h"

@interface VTDCoreDataStore ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation VTDCoreDataStore

- (id)init
{
    if ((self = [super init]))
    {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error = nil;
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"VIPER-TODO.sqlite"];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:options error:&error];
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _managedObjectContext.undoManager = nil;
        
    }
    
    return self;
}


- (void)fetchEntriesWithPredicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray *)sortDescriptors
                  completionBlock:(VTDDataStoreFetchCompletionBlock)completionBlock
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TodoItem"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:nil];
    
    [self.managedObjectContext performBlock:^{
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
        
        if (completionBlock)
        {
            completionBlock(results);
        }
    }];
}


- (VTDManagedTodoItem *)newTodoItem
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TodoItem"
                                                         inManagedObjectContext:self.managedObjectContext];
    VTDManagedTodoItem *newEntry = (VTDManagedTodoItem *)[[NSManagedObject alloc] initWithEntity:entityDescription
                                              insertIntoManagedObjectContext:self.managedObjectContext];
    
    return newEntry;
}


- (void)save
{
    [self.managedObjectContext save:NULL];
}

@end
