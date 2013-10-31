
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ARTFontSize) {
    ARTSmallSizeFont = 8,
    ARTMediumSizeFont = 15,
    ARTLargeSizeFont = 30
};

@interface ARTProgressView : UIProgressView
{
    UILabel *lblTitle;
    UILabel *lblValue;
    BOOL isAscending;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *valueTag;
@property (nonatomic) NSNumber *maxValue;
@property (nonatomic) UIFont *font;

-(void)reset;

@end
