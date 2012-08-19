//
//  SelectedView.m
//  ASIHttpTest
//
//  Created by admin on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectedView.h"

static NSString *content = @" 将诗文本意的解读嵌入现代人对于诗文的引\n用背景及现代人对其引用诗文深意的分析之中的体例安排，就体现了本书作者的隐微意图——以古诗文关照现实。通过对于文本内容的解析可以更清楚地看到这一点。作品内容分析部分，本书作者着力甚深，不仅仅指出诗歌本身的内容，还通过作品写作背景或者原著者的生活经历或明或暗地指出了诗歌写作的隐微之处。如“士不可以不弘毅，任重而道远”一文。本书作者引用了《论语》中的“行已有耻，使于四方，不辱君命，可谓士矣”、“切切偲偲，怡怡如也，可谓士矣”说明“士不可以不弘毅，任重而道远”中的“士”并不仅仅是后世所指的普通读书人，而是“理想人格的典型楷模与儒家社会理想的坚定执行者可以更清楚地看到这一点。作品内容分一点。作品内容分析部分，本书作者着力甚深，不仅仅指出诗歌本身的内容，还通过作品写作背景或者原著者的生活经历或明或暗";

@implementation SelectedView

-(void)select:(UIButton *)sender
{
    NSLog(@"selected String:%@",selectedString);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择文字" message:selectedString delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isShowTip = FALSE;
        if(nil == tipView)
        {            
            tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 35)];
            tipView.backgroundColor = [UIColor blueColor];
            UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];

            [selectBtn setTitle:@"选择" forState:UIControlStateNormal];

            [selectBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
            [tipView addSubview:selectBtn];
            [selectBtn release];
            UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 70, 35)];
            [shareBtn setTitle:@"分享" forState:UIControlStateNormal];

            [tipView addSubview:shareBtn];
            [self addSubview:tipView];
            [shareBtn release];
            tipView.hidden = YES;
            font = [UIFont systemFontOfSize:17];
            lineArray = [[NSMutableArray alloc] init];
            NSLog(@"font.lineHeight:%f",font.lineHeight);
            lineArray = [self cutTextIntoLine:content];
        }
        [self addLongPressGuesture];
        
    }
    return self;
}


-(void)longPress:(UILongPressGestureRecognizer*)guesture
{
   // isShowTip = TRUE;
    NSLog(@"longPress");
    if(guesture.state == UIGestureRecognizerStateBegan)
    {
        firstRect = CGRectMake(0, 0, 0, 0);
        secondRect = CGRectMake(0, 0, 0, 0);
        thirdRect = CGRectMake(0, 0, 0, 0);
        tipView.hidden = YES;
        beginPoint = [guesture locationInView:self];
        beginPoint = [self roundLinePoint:beginPoint];
        beginPoint = [self getLinePosition:beginPoint];
        
    }
    if(guesture.state == UIGestureRecognizerStateChanged)
    {
        if(beginPoint.y > endPoint.y)
        {
            int temp = 0;
            temp = beginPoint.y;
            beginPoint.y = endPoint.y;
            endPoint.y = temp;
        } 
        
        tipView.hidden = YES;
        endPoint = [guesture locationInView:self];
        endPoint = [self roundLinePoint:endPoint];
       endPoint = [self getLinePosition:endPoint];
        selectRect = CGRectMake(beginPoint.x, beginPoint.y,
                                       endPoint.x -beginPoint.x, endPoint.y - beginPoint.y);
        [self parseRect:beginPoint endPoint:endPoint];
        if(nil!=selectedString)
        {
            [selectedString release];
            selectedString = nil;
        }
        selectedString = [self parseString:beginPoint endPoint:endPoint];
        [selectedString retain];
        NSLog(@"selectedString:%@",selectedString);
        [self setNeedsDisplay];
    }
    if(guesture.state == UIGestureRecognizerStateEnded)
    {
       
       if(beginPoint.y > endPoint.y)
       {
           int temp = 0;
           temp = beginPoint.y;
           beginPoint.y = endPoint.y;
           endPoint.y = temp;
       } 
        endPoint = [guesture locationInView:self];
        endPoint = [self roundLinePoint:endPoint];
       // endPoint = [self getLine:content andPosition:endPoint];
       endPoint = [self getLinePosition:endPoint];
           int topy = beginPoint.y;
           int buttomy = 480 - endPoint.y;
       if(topy >buttomy)
       {
           tipView.frame = CGRectMake(90, beginPoint.y , 140, 35);
       }
       else
       {
            tipView.frame = CGRectMake(90, endPoint.y + 5 + font.lineHeight , 140, 35);
       }
       tipView.hidden = NO;
    }

}

-(void)addLongPressGuesture
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPressGesture];
    [longPressGesture release];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)drawRect:(CGRect)rect
{
    
    context = nil;
    context = UIGraphicsGetCurrentContext(); 



    
    CGColorRef bgColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);

    
    CGContextFillRect(context, firstRect);
    CGContextFillRect(context, secondRect);
    CGContextFillRect(context, thirdRect);
    for(int i =0;i<[lineArray count];i++)
    {
        [[lineArray objectAtIndex:i] drawAtPoint:CGPointMake(10, i*font.lineHeight+10) withFont:font];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    firstRect = CGRectMake(0, 0, 0, 0);
    secondRect = CGRectMake(0, 0, 0, 0);
    thirdRect = CGRectMake(0, 0, 0, 0);

    tipView.hidden = YES;
    selectRect = CGRectMake(0, 0, 0, 0);
    selectedString = nil;
    [self setNeedsDisplay];
}



-(CGPoint)roundLinePoint:(CGPoint)srcPoint
{
    int y = srcPoint.y -10 ;
    rowNum = y/(font.lineHeight);
    CGPoint destPoint = CGPointMake(srcPoint.x, rowNum*font.lineHeight+10);
    return destPoint;
}

-(CGPoint)getLinePosition:(CGPoint)currPoint
{
    NSString *rowStr;
    if(rowNum>lineArray.count -1)
    {
        rowStr = [lineArray objectAtIndex:lineArray.count -1];
    }else
    {
        rowStr = [lineArray objectAtIndex:rowNum];
    }
    for(int i = 1;i<rowStr.length;i++)
    {
        NSString *tempStr = [rowStr substringToIndex:i];

        CGSize tempSize = [tempStr sizeWithFont:font];
        
        if(tempSize.width + 10 < currPoint.x )
        {
            tempStr = [rowStr substringToIndex:i+1];

            CGSize tempSize = [tempStr sizeWithFont:font];
            if(tempSize.width +10 > currPoint.x )
            {
                tempStr = [rowStr substringToIndex:i];
                CGSize tempSize = [tempStr sizeWithFont:font];
                return  CGPointMake(tempSize.width +10, currPoint.y);
            }
        }
    }
}

-(void)parseRect:(CGPoint)begin endPoint:(CGPoint )end
{
    beginPoint = [self roundLinePoint:begin];
    beginPoint = [self getLinePosition:beginPoint];
    endPoint = [self roundLinePoint:end];
    endPoint = [self roundLinePoint:endPoint];
    
    
    NSLog(@"ssssssss:%d",(endPoint.y - beginPoint.y)/(font.lineHeight));

    if ((endPoint.y - beginPoint.y)/(font.lineHeight) == 0)                                                         //1 行
    {
        firstRect = CGRectMake(beginPoint.x, beginPoint.y
                               ,endPoint.x -beginPoint.x,font.lineHeight);
        secondRect = CGRectMake(0, 0, 0, 0);
        thirdRect = CGRectMake(0, 0, 0, 0);
        
    }
   else if((endPoint.y - beginPoint.y)/(font.lineHeight) == 1)       //2 行
   {
       firstRect = CGRectMake(beginPoint.x, beginPoint.y
                              ,(310-selectRect.origin.x),font.lineHeight);
       secondRect =  CGRectMake(10, endPoint.y,endPoint.x -10, font.lineHeight);
       thirdRect = CGRectMake(0, 0, 0, 0);
   }

   else if((endPoint.y - beginPoint.y)/(font.lineHeight)>1)             //3 行以上
    {
        firstRect = CGRectMake(beginPoint.x, beginPoint.y
                               ,(310-selectRect.origin.x),font.lineHeight);
        secondRect = CGRectMake(10, selectRect.origin.y+font.lineHeight, 300,
                                (((endPoint.y - beginPoint.y)/(font.lineHeight)-1)*font.lineHeight));
        thirdRect = CGRectMake(10, endPoint.y,endPoint.x -10, font.lineHeight);
        
    }
    return;

}

-(NSMutableArray *)cutTextIntoLine:(NSString *)src
{
    
    for(int i =1;i<src.length;i++)
    {
        NSString *temp = [src substringToIndex:i];
        CGSize  selectRect = [src sizeWithFont:font];
        if(selectRect.width <300)
        {
            [lineArray addObject:src];
            NSLog(@"lineStr:%@",src);
            return lineArray;
        }
        
        selectRect = [temp sizeWithFont:font constrainedToSize:CGSizeMake(300, 480) lineBreakMode:UILineBreakModeWordWrap];
        
        if(selectRect.width <=300)
        {
            NSString *temp = [src substringToIndex:i+1];
            CGSize selectRect = [temp sizeWithFont:font];
            if(selectRect.width >=300)
            {
                NSString *temp = [src substringToIndex:i];
                [lineArray addObject:temp];
                NSLog(@"lineStr:%@",temp);
                temp = [src substringFromIndex:i];
                [self cutTextIntoLine:temp];
                return lineArray;
            }
        }
    }
    [self setNeedsDisplay];
}


-(NSString *)parseString:(CGPoint)begin endPoint:(CGPoint )end
{
    NSString *selectStr ;
    if(beginPoint.y > endPoint.y)
    {
        int temp = 0;
        temp = beginPoint.y;
        beginPoint.y = endPoint.y;
        endPoint.y = temp;
    }
    
    beginPoint = [self roundLinePoint:begin];
    beginPoint = [self getLinePosition:beginPoint];
    
    endPoint = [self roundLinePoint:end];
    endPoint = [self getLinePosition:endPoint];
    if(beginPoint.x == endPoint.x && beginPoint.y == endPoint.y)
    {
        return nil;
    }
    
    if((endPoint.y - beginPoint.y)/(font.lineHeight)==0)       //1 行
    {
        
        NSString *rowStr =[lineArray objectAtIndex:[self getTheNumberOfLine:begin]];
        NSLog(@"rowStr:%@",rowStr);
        NSRange range  = NSMakeRange([self getIndexOfPositionInRow:begin]+1,
                                     [self getIndexOfPositionInRow:endPoint]-[self getIndexOfPositionInRow:begin]);
        NSLog(@"beginPosition:%d",[self getIndexOfPositionInRow:begin]);
         NSLog(@"enDposition:%d",[self getIndexOfPositionInRow:endPoint]);
        selectStr = [rowStr substringWithRange:range];
        
        NSLog(@"selectStr:%@",selectStr);
    }

    else if((endPoint.y - beginPoint.y)/(font.lineHeight)==1)       //2 行
    {
        
        NSString *rowStr =[lineArray objectAtIndex:[self getTheNumberOfLine:begin]];

        NSRange range  = NSMakeRange([self getIndexOfPositionInRow:begin]+1,
                                     rowStr.length -[self getIndexOfPositionInRow:begin]-1);
        
        selectStr = [rowStr substringWithRange:range];
 
        
        NSString *nextRowStr =[lineArray objectAtIndex:[self getTheNumberOfLine:endPoint] ];

        range  = NSMakeRange(0,[self getIndexOfPositionInRow:endPoint]+1);
        NSString *nextRowSelectStr = [nextRowStr substringWithRange:range];
        selectStr = [selectStr stringByAppendingString:nextRowSelectStr];
   
    }
    else                                                         //3 行
    {
        
        NSString *rowStr =[lineArray objectAtIndex:[self getTheNumberOfLine:begin]];
    
        NSRange range  = NSMakeRange([self getIndexOfPositionInRow:begin]+1,
                                     rowStr.length -[self getIndexOfPositionInRow:begin]-1);
        
        selectStr = [rowStr substringWithRange:range];
    
        for(int i = [self getTheNumberOfLine:beginPoint]+1;i<=[self getTheNumberOfLine:endPoint]-1;i++)
        {
            selectStr = [selectStr stringByAppendingString:[lineArray objectAtIndex:i]];

        }
        NSString *nextRowStr =[lineArray objectAtIndex:[self getTheNumberOfLine:endPoint] ];
        range  = NSMakeRange(0,[self getIndexOfPositionInRow:endPoint]+1);
        NSString *nextRowSelectStr = [nextRowStr substringWithRange:range];
        selectStr = [selectStr stringByAppendingString:nextRowSelectStr];
        NSLog(@"&&&&&&&&&selectStr:%@",selectStr);
        
    }

    return selectStr;
}

-(int)getIndexOfPositionInRow:(CGPoint)point
{
    NSString *rowStr = [lineArray objectAtIndex:[self getTheNumberOfLine:point]];
    
    for(int i = 0;i<rowStr.length;i++)      //i
    {
        NSString *tempStr = [rowStr substringToIndex:i];
        
        CGSize tempSize = [tempStr sizeWithFont:font];
        
        if(tempSize.width + 10 < point.x )
        {
            tempStr = [rowStr substringToIndex:i+1];
            
            CGSize tempSize = [tempStr sizeWithFont:font];
            if(tempSize.width +10 >= point.x)
            {
                tempStr = [rowStr substringToIndex:i];
                CGSize tempSize = [tempStr sizeWithFont:font];
                if(rowStr.length <= i)
                {
                    return rowStr.length -1;
                }
                else
                {
                    return i ;
                }
            }
        }
  
    }
                              //无这返回，默认返回一个随机值
    return 0;

}

-(int)getTheNumberOfLine:(CGPoint)point
{
    return (point.y -10)/font.lineHeight;
}






@end
