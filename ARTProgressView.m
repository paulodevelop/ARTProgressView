
#import "ARTProgressView.h"

@implementation ARTProgressView

@synthesize maxValue;

float const kLabelProgressSpace = 2.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        
        _font = [[UIFont alloc]init];
        
        lblTitle = [[UILabel alloc]init];
        lblTitle.backgroundColor = [UIColor clearColor];
        
        self.progressViewStyle = UIProgressViewStyleDefault;
        
        lblValue = [[UILabel alloc]init];
        lblValue.textAlignment = NSTextAlignmentLeft;
        lblValue.backgroundColor = [UIColor clearColor];
        lblValue.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        lblValue.shadowOffset = CGSizeMake(1.0, 1.0);
        lblValue.text = @""; // default value
        _valueUnit = @""; // default suffix

        [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
        [self addSubview:(UIView *) lblTitle];
        [self addSubview:(UIView *) lblValue];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"])
    {
        if ([[change objectForKey:NSKeyValueChangeNewKey] doubleValue] >= [[change objectForKey:NSKeyValueChangeOldKey] doubleValue])
            isAscending = TRUE;
        else
            isAscending = FALSE;
    }
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    
    // Apparently when animated=YES, the progress property is not assigned within the ProgressView. This is needed to evaluate through KVO if progress is ascending or descending
    if (animated) self.progress = progress;
    
    [super setProgress:progress animated:animated];
    
    if (!isAscending)
    {
        if (lblValue.frame.origin.x >= progress * self.frame.size.width)
            lblValue.frame = CGRectMake(progress * CGRectGetWidth(self.frame), CGRectGetMinY(lblValue.frame), CGRectGetWidth(lblValue.frame) , CGRectGetHeight(lblValue.frame));
    }
    else if (isAscending) {
        
        if (CGRectGetMinX(lblValue.frame) + CGRectGetWidth(lblValue.frame) <= progress * CGRectGetWidth(self.frame))
            lblValue.frame = CGRectMake(progress * CGRectGetWidth(self.frame) - CGRectGetWidth(lblValue.frame), CGRectGetMinY(lblValue.frame), CGRectGetWidth(lblValue.frame) , CGRectGetHeight(lblValue.frame));
    }
    
    lblValue.text = [NSString stringWithFormat:@"%.1f %@", progress  * [maxValue floatValue], _valueUnit];
    [lblValue sizeToFit];
}

#pragma mark ARTProgressView properties

- (void)setFont:(UIFont *)aFont {
    
    lblTitle.font = aFont;
    lblValue.font = aFont;
    
    [self LabelSizingPositioning];
}

- (void)setTitle:(NSString *)aText {
    
    lblTitle.text = aText;
    [lblTitle sizeToFit];

    [self LabelSizingPositioning];
}

- (void)setMaxValue:(NSNumber *)aMaxValue {
    
    maxValue = aMaxValue;
    lblValue.text = [NSString stringWithFormat:@"%.1f %@", [aMaxValue floatValue], _valueUnit];
    [lblValue sizeToFit];
    
    [self LabelSizingPositioning];
}

#pragma mark ARTProgressView methods

- (void)reset
{
    lblValue.text = [NSString stringWithFormat:@"%.1f %@", [maxValue floatValue], _valueUnit];
    [lblValue sizeToFit];
    
    [self LabelSizingPositioning];
}

- (void)LabelSizingPositioning
{
    lblTitle.frame = CGRectMake(CGRectGetMinX(lblTitle.frame), CGRectGetHeight(lblTitle.frame)*(-1), CGRectGetWidth(self.frame), CGRectGetHeight(lblTitle.frame));
    
    if (self.progress * CGRectGetWidth(self.frame) - CGRectGetWidth(lblValue.frame) <= 0.0)
        lblValue.frame = CGRectMake(0, kLabelProgressSpace, CGRectGetWidth(lblValue.frame), CGRectGetHeight(lblValue.frame));
    else
        lblValue.frame = CGRectMake(self.progress * CGRectGetWidth(self.frame) - CGRectGetWidth(lblValue.frame), CGRectGetMinY(lblValue.frame), CGRectGetWidth(lblValue.frame) , CGRectGetHeight(lblValue.frame));
}

@end
