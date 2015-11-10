//
//  HorizonalItemList.m
//  AutoLayoutAnimation
//
//  Created by Tran Tuan Hai on 10/20/15.
//  Copyright © 2015 Tran Tuan Hai. All rights reserved.
//

#import "HorizonalItemList.h"

static const float buttonWidth = 60.0f;
static const float padding = 10.0f;

@implementation HorizonalItemList

- (instancetype)initInView:(UIView*)inView{
  CGRect rect = CGRectMake(inView.bounds.size.width, 120.0f, inView.bounds.size.width, 80.0f);
  if (self = [super initWithFrame:rect]) {
    self.alpha = 0.0f;
    for (int i = 0; i < 10; i++) {
      NSString *imageName = [NSString stringWithFormat:@"summericons_100px_0%i.png",i];
      UIImage *image = [UIImage imageNamed:imageName];
      UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
      imageView.center = CGPointMake(buttonWidth * i + buttonWidth/2, buttonWidth/2);
      imageView.tag = i;
      imageView.userInteractionEnabled = YES;
      [self addSubview:imageView];
      UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
      [imageView addGestureRecognizer:tap];
    }
    self.contentSize = CGSizeMake(padding * buttonWidth, buttonWidth + 2*padding);
  }
  return self;
}

- (void)didTapImage:(UITapGestureRecognizer*)tap{
  if (self.didSelectItem) {
    self.didSelectItem(tap.view.tag);
  }
}

- (void)didMoveToSuperview{
  [super didMoveToSuperview];
  if (self.superview == nil) {
    return;
  }
  [UIView animateWithDuration:1.0f
                        delay:0.01f
       usingSpringWithDamping:0.5f
        initialSpringVelocity:10.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     self.alpha = 1.0f;
                     self.center = ({
                       CGPoint center = self.center;
                       center.x -= self.frame.size.width;
                       center;
                     });} completion:nil];
}


@end
