//
//  MainViewController.m
//  PaginatedCollectionView
//
//  Created by Jason Jarrett on 3/11/14.
//  Copyright (c) 2014 0.0.1. All rights reserved.
//


/*
   http://adoptioncurve.net/archives/2012/09/a-simple-uicollectionview-tutorial/
   https://github.com/timd/CollectionViewExample/tree/master/CollectionViewExample

 
   https://github.com/subdigital/nsscreencast/blob/master/008-automatic-paging/BeerScroller/BeerScroller/ViewController.h
 
 */

#import "MainViewController.h"
#import "Cell.h"


#define ITEMS_PAGE_SIZE 4
#define ITEM_CELL_IDENTIFIER @"ItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.items = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    
    // Configure layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // return one plus current count to trigger the fetchingMoreItems
    
    return self.items.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item < self.items.count) {
        
        // pre-fetch the next 'page' of data.
        if(indexPath.item == (self.items.count - ITEMS_PAGE_SIZE + 1)){
            [self fetchMoreItems];
        }
        
        return [self itemCellForIndexPath:indexPath];
    } else {
        [self fetchMoreItems];
        return [self loadingCellForIndexPath:indexPath];
    }
}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath {
    
    Cell *cell = (Cell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL_IDENTIFIER forIndexPath:indexPath];
    
    // Update the custom cell with some text
    cell.titleLabel.text = [NSString stringWithFormat:@"indexPath.item: %d \nValue: %@", indexPath.item, self.items[indexPath.item]];
    
    return cell;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {

    Cell *cell = (Cell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 90, 10);
}

- (void)fetchMoreItems {
    NSLog(@"FETCHING MORE ITEMS ******************");
    
    // Generate the 'next page' of data.
    NSMutableArray *newData = [NSMutableArray array];
    NSInteger pageSize = ITEMS_PAGE_SIZE;
    for (int i = _currentPage * pageSize; i < ((_currentPage * pageSize) + pageSize); i++) {
        [newData addObject:[NSString stringWithFormat:@"Item #%d", i]];
    }
    
    _currentPage++;
    
    
    // Simulate an async load...
    
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        // Add the new data to our local collection of data.
        for (int i = 0; i < newData.count; i++) {
            [self.items addObject:newData[i]];
        }
        
        // Tell the collectionView to reload.
        [self.collectionView reloadData];
        
    });
}


@end
