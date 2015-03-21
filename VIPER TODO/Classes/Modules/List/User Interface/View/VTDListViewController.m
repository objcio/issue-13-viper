//
// MMTODOListViewController.m
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

#import "VTDListViewController.h"

#import "VTDTodoItem.h"
#import "VTDUpcomingDisplayData.h"
#import "VTDUpcomingDisplaySection.h"
#import "VTDUpcomingDisplayItem.h"


static NSString* const VTDListEntryCellIdentifier = @"VTDListEntryCell";


@interface VTDListViewController ()

@property (nonatomic, strong)   VTDUpcomingDisplayData* data;

// The view controller seems to have a weak reference to the table view.
// We need to keep a strong reference to the table view for times when we remove the table view from the view controller
@property (nonatomic, strong)   UITableView*            strongTableView;

@end


@implementation VTDListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.strongTableView = self.tableView;
    [self configureView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.eventHandler updateView];
}


- (void)configureView
{
    self.navigationItem.title = @"VIPER TODO";
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(didTapAddButton:)];
    self.navigationItem.rightBarButtonItem = addItem;
}


- (void)didTapAddButton:(id)sender
{
    [self.eventHandler addNewEntry];
}


- (void)showNoContentMessage
{
    self.view = self.noContentView;
}


- (void)showUpcomingDisplayData:(VTDUpcomingDisplayData *)data
{
    self.view = self.strongTableView;
    
    self.data = data;
    [self reloadEntries];
}


- (void)reloadEntries
{
    [self.strongTableView reloadData];
}


#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data.sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    VTDUpcomingDisplaySection *upcomingSection = self.data.sections[section];
    
    return [upcomingSection.items count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    VTDUpcomingDisplaySection *upcomingSection = self.data.sections[section];
    
    return upcomingSection.name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VTDUpcomingDisplaySection *section = self.data.sections[indexPath.section];
    VTDUpcomingDisplayItem *item = section.items[indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:VTDListEntryCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.dueDay;
    cell.imageView.image = [UIImage imageNamed:section.imageName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
