//
//  MainViewController.h
//  PaginatedCollectionView
//
//  Created by Jason Jarrett on 3/11/14.
//  Copyright (c) 2014 0.0.1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSInteger _currentPage;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) NSMutableArray *items;

- (void)fetchMoreItems;

@end
