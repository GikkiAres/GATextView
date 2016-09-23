//
//  GATextView.h
//  GATextView
//
//  Created by GikkiAres on 9/23/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GATextView;
@protocol GATextViewDelegate <NSObject>

- (void)GATextViewHeightHasChanged:(GATextView *)textView;

@end



IB_DESIGNABLE
@interface GATextView : UITextView
//placeholder
@property (nonatomic,strong)IBInspectable UIColor *placeholderColor;
@property (nonatomic,strong)IBInspectable NSString* placeholder;
//border
@property (nonatomic,strong)IBInspectable UIColor *borderColor;
@property (nonatomic,assign)IBInspectable CGFloat borderWidth;
//cornerRadius
@property (nonatomic,assign)IBInspectable CGFloat cornerRadius;
//长度限制
//-1表示没有限制
@property (nonatomic,assign)IBInspectable NSInteger maxTextLength;

//当文字变多时,是否高度自动增加.
@property (nonatomic,assign)IBInspectable BOOL autoAdjustHeight;

//匹配文字的高度
@property (nonatomic,assign) CGFloat calculatedTextHeight;

@property (nonatomic,weak) id<GATextViewDelegate> delegateGA;

@end
