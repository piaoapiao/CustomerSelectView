//
//  SelectedView.h
//  ASIHttpTest
//
//  Created by admin on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedView : UIView
{
    CGPoint         beginPoint;
    CGPoint         endPoint;
    CGRect          selectRect;
    CGRect          firstRect;
    CGRect          secondRect;
    CGRect          thirdRect;
    UIView          *tipView;
    BOOL            isShowTip;
    UIFont          *font;
    CGContextRef context;
    NSMutableArray *lineArray;
    int             rowNum;     //第几行
    NSString *selectedString;

}
-(void)addLongPressGuesture;
-(CGPoint)roundLinePoint:(CGPoint)srcPoint;
//-(CGPoint)getLine:(NSString *)rowStr andPosition:(CGPoint)currPoint;
-(CGPoint)getLinePosition:(CGPoint)currPoint;
-(void)parseRect:(CGPoint)beginPoint endPoint:(CGPoint )endPoint;
-(NSMutableArray *)cutTextIntoLine:(NSString *)src;
@end
