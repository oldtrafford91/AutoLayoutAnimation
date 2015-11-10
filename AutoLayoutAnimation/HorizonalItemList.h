//
//  HorizonalItemList.h
//  AutoLayoutAnimation
//
//  Created by Tran Tuan Hai on 10/20/15.
//  Copyright © 2015 Tran Tuan Hai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonalItemList : UIScrollView

@property (nonatomic, copy) void(^didSelectItem)(NSInteger);

- (instancetype)initInView:(UIView*)inView;

@end
