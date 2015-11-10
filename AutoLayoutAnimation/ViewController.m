//
//  ViewController.m
//  AutoLayoutAnimation
//
//  Created by Tran Tuan Hai on 10/20/15.
//  Copyright © 2015 Tran Tuan Hai. All rights reserved.
//

#import "ViewController.h"
#import "HorizonalItemList.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHeightConstraint;

@end

@implementation ViewController{
  HorizonalItemList *_slider;
  BOOL _isMenuOpen;
  NSMutableArray *_items;
  NSArray *_itemTitles;
}

#pragma mark - IBAction

- (IBAction)toogleMenu:(id)sender {
  //List all constraint
  for (NSLayoutConstraint *constraint in self.titleLabel.superview.constraints) {
    NSLog(@"Before: %@",constraint);
  }
  
  _isMenuOpen = !_isMenuOpen;
  for (NSLayoutConstraint *constraint in self.titleLabel.superview.constraints) {
    if (constraint.firstItem == self.titleLabel && constraint.firstAttribute == NSLayoutAttributeCenterX) {
      // Change constraint constant
      constraint.constant = _isMenuOpen ? -100.0f : 0.0f;
      continue;
    }
    
    if (constraint.firstItem == self.titleLabel && constraint.firstAttribute == NSLayoutAttributeCenterY) {
      // Remove constraint
      [self.titleLabel.superview removeConstraint:constraint];
      
      NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.titleLabel.superview
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier: _isMenuOpen ? 0.67 : 1.0
                                                                        constant:5];
      newConstraint.active = YES;
      continue;
    }
  }
  
  self.menuHeightConstraint.constant = _isMenuOpen ? 200 : 60;
  self.titleLabel.text = _isMenuOpen ? @"Select Item" : @"Packing List";
  
  [UIView animateWithDuration:1.0f
                        delay:0.0f
       usingSpringWithDamping:0.4f
        initialSpringVelocity:10.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [self.view layoutIfNeeded];
                     CGFloat angle = _isMenuOpen ? M_PI_4 : 0.0f;
                     self.buttonMenu.transform = CGAffineTransformMakeRotation(angle);
                   } completion:nil];
  
  if (_isMenuOpen) {
    _slider = [[HorizonalItemList alloc] initInView:self.view];
    __weak typeof(self) weakSelf = self;
    _slider.didSelectItem = ^(NSInteger tag){
      NSLog(@"%lu",tag);
      __strong typeof(self) strongSelf = weakSelf;
      [strongSelf->_items addObject:@(tag)];
      [strongSelf.tableView reloadData];
      [strongSelf toogleMenu:strongSelf];
    };
    [self.titleLabel.superview addSubview:_slider];
  }else{
    [_slider removeFromSuperview];
  }
}
#pragma mark - View Life Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
  _items = [@[@5, @6, @7] mutableCopy];
  _itemTitles = @[@"Icecream money", @"Great weather", @"Beach ball", @"Swim suit for him", @"Swim suit for her", @"Beach games", @"Ironing board", @"Cocktail mood", @"Sunglasses", @"Flip flops"];
  _isMenuOpen = NO;
  
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  if (cell) {
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSInteger index = [(NSNumber*)_items[indexPath.row] integerValue];
    cell.textLabel.text = _itemTitles[index];
    NSString *imageName = [NSString stringWithFormat:@"summericons_100px_0%lu.png",index];
    cell.imageView.image = [UIImage imageNamed:imageName];
  }
  return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSInteger item = [_items[indexPath.row] integerValue];
  [self showItem:item];
}

- (void)showItem:(NSInteger)index{
  NSLog(@"Tapped item %lu",index);
  
  //Create imageView for display item
  UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"summericons_100px_0%lu.png",index]];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
  imageView.layer.cornerRadius = 5.0f;
  imageView.layer.masksToBounds = YES;
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:imageView];
  
  //Add constraints to imageView
  NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:imageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f];
  constraintX.active = YES;
  NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:imageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:imageView.bounds.size.height];
  constraintY.active = YES;
  NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:0.33f
                                                                      constant:-50.0f];
  constraintWidth.active = YES;
  NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:imageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0f
                                                                      constant:0.0f];
  constraintHeight.active = YES;
  [self.view layoutIfNeeded];
  
  //Animate constraints
  [UIView animateWithDuration:0.8f
                        delay:0.0f
       usingSpringWithDamping:0.4f
        initialSpringVelocity:0.0f
                      options:0
                   animations:^{
                     constraintY.constant = -imageView.bounds.size.height/2;
                     constraintWidth.constant = 0.0f;
                     [self.view layoutIfNeeded];
                   } completion:nil];
  
  [UIView animateWithDuration:0.8f
                        delay:1.0f
       usingSpringWithDamping:0.4f
        initialSpringVelocity:0.0f
                      options:0
                   animations:^{
                     constraintY.constant = imageView.bounds.size.height;
                     constraintWidth.constant = -50.0f;
                     [self.view layoutIfNeeded];
                   } completion:^(BOOL finished){
                     [imageView removeFromSuperview];
                   }];

}

@end
