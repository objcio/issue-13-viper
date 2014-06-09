//
// VTDAppDependencies.m
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

#import "VTDAppDependencies.h"

#import "VTDRootWireframe.h"

#import "VTDCoreDataStore.h"
#import "VTDDeviceClock.h"

#import "VTDListDataManager.h"
#import "VTDListInteractor.h"
#import "VTDListPresenter.h"
#import "VTDListWireframe.h"

#import "VTDAddDataManager.h"
#import "VTDAddInteractor.h"
#import "VTDAddPresenter.h"
#import "VTDAddWireframe.h"

@interface VTDAppDependencies ()

@property (nonatomic, strong) VTDListWireframe *listWireframe;

@end


@implementation VTDAppDependencies

- (id)init
{
    if ((self = [super init]))
    {
        [self configureDependencies];
    }
    
    return self;
}


- (void)installRootViewControllerIntoWindow:(UIWindow *)window
{
    [self.listWireframe presentListInterfaceFromWindow:window];
}


- (void)configureDependencies
{
    // Root Level Classes
    VTDCoreDataStore *dataStore = [[VTDCoreDataStore alloc] init];
    id<VTDClock> clock = [[VTDDeviceClock alloc] init];
    VTDRootWireframe *rootWireframe = [[VTDRootWireframe alloc] init];
    
    // List Modules Classes
    VTDListWireframe *listWireframe = [[VTDListWireframe alloc] init];
    VTDListPresenter *listPresenter = [[VTDListPresenter alloc] init];
    VTDListDataManager *listDataManager = [[VTDListDataManager alloc] init];
    VTDListInteractor *listInteractor = [[VTDListInteractor alloc] initWithDataManager:listDataManager clock:clock];
    
    // Add Module Classes
    VTDAddWireframe *addWireframe = [[VTDAddWireframe alloc] init];
    VTDAddInteractor *addInteractor = [[VTDAddInteractor alloc] init];
    VTDAddPresenter *addPresenter = [[VTDAddPresenter alloc] init];
    VTDAddDataManager *addDataManager = [[VTDAddDataManager alloc] init];
    
    // List Module Classes
    listInteractor.output = listPresenter;
    
    listPresenter.listInteractor = listInteractor;
    listPresenter.listWireframe = listWireframe;
    
    listWireframe.addWireframe = addWireframe;
    listWireframe.listPresenter = listPresenter;
    listWireframe.rootWireframe = rootWireframe;
    self.listWireframe = listWireframe;
    
    listDataManager.dataStore = dataStore;
    
    // Add Module Classes
    addInteractor.addDataManager = addDataManager;
    
    addPresenter.addInteractor = addInteractor;
    
    addWireframe.addPresenter = addPresenter;
    
    addPresenter.addWireframe = addWireframe;
    addPresenter.addModuleDelegate = listPresenter;
    
    addDataManager.dataStore = dataStore;
}

@end
