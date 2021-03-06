
#import <UIKit/UIKit.h>
#import "common.h"
#import "StringUitl.h"
#import "UIImageView+WebCache.h"
typedef enum
{
    FFScrollViewSelecttionTypeTap = 100,  //默认的为可点击模式
    FFScrollViewSelecttionTypeNone   //不可点击的
}FFScrollViewSelecttionType;

@protocol FFScrollViewDelegate <NSObject>

@optional
- (void)scrollViewDidClickedAtPage:(NSInteger)pageNumber;

@end

@interface FFScrollView : UIView <UIScrollViewDelegate>
{
    NSTimer *timer;
    NSArray *sourceArr;
}
@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) UIPageControl *pageControl;
@property(assign,nonatomic) FFScrollViewSelecttionType selectionType;
@property(assign,nonatomic) id <FFScrollViewDelegate> pageViewDelegate;
- (id)initPageViewWithFrame:(CGRect)frame views:(NSArray *)views;

@end
