#import "ViewController.h"
#import "Place.h"
#import "CustomSearch.h"
#import "DishesViewController.h"
@import GoogleMaps;

@interface ViewController () <NSCoding>

// Instantiate a pair of UILabels in Interface Builder
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property UIImageView *placeThumb;
@property UIImageView *placeThumbBG;
@property IBOutlet UIButton *dishesButton;
@property Place* currPlace;
- (IBAction)segue:(id)sender;
@end

//search engine id 015953250158261179188:9pejrsb_z9g
//api key AIzaSyBTMyOq_ihH677VN-BwwV15TVviKunVF4o
//googleapis.com/customsearch/v1?q=a&key=%7BAIzaSyBTMyOq_ihH677VN-BwwV15TVviKunVF4o%7D&cx=%7B015953250158261179188:9pejrsb_z9g%7D

@implementation ViewController {
    GMSPlacesClient *_placesClient;
    NSMutableArray *placesList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self positionPlaceThumb];
    [self positionAndCreateUpdateButton];
    _placesClient = [[GMSPlacesClient alloc] init];
    placesList = [[NSMutableArray alloc] init];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:placesList forKey:@"placesList"];
    NSLog(@"Saved Empty Places Array into Defaults");
    [def synchronize];
    [self getPlace];
    
    self.navigationController.navigationBarHidden = YES;
//    /[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext" size:12]}];
    
    
}

-(BOOL)prefersStatusBarHidden { return YES; }

- (void) positionAndCreateUpdateButton {
    [_dishesButton removeConstraints:_dishesButton.constraints];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    UIColor *prettyBlue = [UIColor colorWithRed:52/255.0 green:152/255.0 blue:219/255.0 alpha:1];
    UIColor *prettyGreen= [UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1];
    UIColor *prettyDarkGreen= [UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1];
    UIColor *prettyDarkBlue = [UIColor colorWithRed:41/255.0 green:128/255.0 blue:185/255.0 alpha:1];
    CGFloat updateButtonWidth = .5*width;
    CGFloat xMargin = (width - updateButtonWidth)/2;
    CGFloat updateButtonHeight = 40.0;
    CGFloat updateButtonSpacingY = 30.0;
    CGFloat yMarginFromButton = height - (2*updateButtonSpacingY) - updateButtonHeight;
    
    CGRect updateButtonFrame = CGRectMake(xMargin, yMarginFromButton, updateButtonWidth, updateButtonHeight);
    _dishesButton = [[UIButton alloc] initWithFrame:updateButtonFrame];
    [_dishesButton setBackgroundImage:[self imageWithColor:prettyBlue] forState:UIControlStateNormal];
    [_dishesButton setBackgroundImage:[self imageWithColor:prettyDarkBlue] forState:UIControlStateHighlighted];
     
    //Add method to go to the dishes view controller.
    [_dishesButton addTarget:self action:@selector(segue:) forControlEvents:UIControlEventTouchUpInside];
    [_dishesButton setTitle:@"⇨" forState:UIControlStateNormal];
    [_dishesButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:15]];
    [self.view addSubview:_dishesButton];

}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(void) positionPlaceThumb {
    [_placeThumb removeConstraints:_placeThumb.constraints];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat placeThumbSize = 175.0;
    CGFloat placeThumbBGSize= placeThumbSize + 5;
    CGFloat xMarginPT = (width - placeThumbSize)/2;
    CGFloat xMarginPTBG = (width - placeThumbBGSize)/2;
    CGFloat yMarginPT = (height/2.5);
    CGFloat yMarginPTBG = (height-5)/2.5;
    CGRect placeThumbframe = CGRectMake(xMarginPT, yMarginPT, placeThumbSize, placeThumbSize);
    _placeThumb = [[UIImageView alloc] initWithFrame:placeThumbframe];
    
    CGRect placeThumbBGFrame = CGRectMake(xMarginPTBG, yMarginPTBG, placeThumbBGSize, placeThumbBGSize);
    _placeThumbBG = [[UIImageView alloc] initWithFrame:placeThumbBGFrame];
    [_placeThumbBG setBackgroundColor:[UIColor whiteColor]];
    
    CAShapeLayer *circleBG = [CAShapeLayer layer];
    UIBezierPath *circularPathBG=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _placeThumbBG.frame.size.width, _placeThumbBG.frame.size.height) cornerRadius:MAX(_placeThumbBG.frame.size.width, _placeThumbBG.frame.size.height)];
    circleBG.path = circularPathBG.CGPath;
    
    circleBG.fillColor = [UIColor blackColor].CGColor;
    circleBG.backgroundColor = [UIColor blackColor].CGColor;
    circleBG.strokeColor = [UIColor blackColor].CGColor;
    circleBG.lineWidth = 0;
    circleBG.borderWidth = 10;
    circleBG.borderColor = [UIColor blackColor].CGColor;
    _placeThumbBG.layer.mask=circleBG;

    
    [self.view addSubview:_placeThumbBG];
    [self.view addSubview:_placeThumb];
}
// Add a UIButton in Interface Builder to call this function
- (IBAction)getCurrentPlace:(UIButton *)sender {
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        self.nameLabel.text = @"No current place";
        self.addressLabel.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
               
                [self showMessage:@"Verify Location" withTitle:[NSString stringWithFormat:@"Are you currently at %@?", place.name] forPlace:place.name];
            }
        }
    }];
}

- (void) getPlace {
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        self.nameLabel.text = @"No current place";
        self.addressLabel.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
                
                [self showMessage:@"Verify Location" withTitle:[NSString stringWithFormat:@"Are you currently at %@?", place.name] forPlace:place.name];
            }
        }
    }];

}

- (IBAction)getDefaults:(id)sender {
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"placesList"]];
    for (Place* p in arr) {
        NSLog(@"%@ read from array in defaults.", p.placeName);
    }
}

-(void)showMessage:(NSString*)message withTitle:(NSString *)title forPlace: (NSString*) placeName {
    UIAlertController *placeVerification = [UIAlertController alertControllerWithTitle:title
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.currPlace = [[Place alloc] initWithPlaceName:placeName];
        [self handlePlace:_currPlace];
        [self setThumbnailForURL:[CustomSearch getImageURL:placeName]];
        [placeVerification dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Wrong Location Found.");
        //still need to handle UI for wrong location.
        [placeVerification dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [placeVerification addAction:yesAction];
    [placeVerification addAction:noAction];
    [self presentViewController:placeVerification animated:YES completion:nil];
}


- (void) handlePlace: (Place *) place {
    if ([self checkPlace:place.placeName]) {
        NSLog(@"%@ already in array", place.placeName);
    } else {
        [self addPlace:place];
        NSLog(@"%@ added to array", place.placeName);
    }
}

- (BOOL) checkPlace:(NSString *) name {
    for (Place* i in placesList) {
        if ([i.placeName isEqualToString:name]) {
            return true;
        }
    }
    return false;
}

- (void) addPlace: (Place *) place {
    NSLog(@"adding new place %@", place.placeName);
    [placesList addObject:place];
    [self encodeAndStoreArray:placesList];
}

-(void) encodeAndStoreArray: (NSMutableArray *) placesArray {
    //Code to serialize each object of array (depth approach)
//    NSMutableArray *toArchive = [NSMutableArray arrayWithCapacity:placesArray.count];
//    for (Place *place in placesArray) {
//        NSData *encodedPlaceObj = [NSKeyedArchiver archivedDataWithRootObject:place];
//        [toArchive addObject:encodedPlaceObj];
//    }
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:toArchive forKey:@"placesList"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Code to serialize array-first (blanket approach)
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *toArchive = [NSKeyedArchiver archivedDataWithRootObject:placesList];
    [def setObject:toArchive forKey:@"placesList"];
    [def synchronize];
    NSLog(@"Encoded and stored array."); 

}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:placesList forKey:@"placesList"];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        placesList = [aDecoder decodeObjectForKey:@"placesList"];
    }
    return self;
}
#pragma clang diagnostic pop

- (void) setThumbnailForURL:(NSURL*)URL {
    [self.placeThumb setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:URL]]];
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _placeThumb.frame.size.width, _placeThumb.frame.size.height) cornerRadius:MAX(_placeThumb.frame.size.width, _placeThumb.frame.size.height)];
    circle.path = circularPath.CGPath;
    
    circle.fillColor = [UIColor blackColor].CGColor;
    circle.backgroundColor = [UIColor blackColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 0;
    circle.borderWidth = 10;
    circle.borderColor = [UIColor blackColor].CGColor;
    _placeThumb.layer.mask=circle;
}

- (void) setHasBeenHereLabelText: (Place *) place {
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"placesList"]];
    for (Place* p in arr) {
        if ([place.placeName isEqualToString:p.placeName]) {
            //set text
        } else {
            //set text
        }
        NSLog(@"%@ read from array in defaults.", p.placeName);
    }
}

-(void) setBackground {
    [self.view setBackgroundColor:[UIColor colorWithRed:142/255.0 green:68/255.0 blue:173/255.0 alpha:1]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Identifier"]){
        DishesViewController *dishesVC = (DishesViewController *)segue.destinationViewController;
        dishesVC.place = _currPlace;
        NSLog(@"Set the current place in Dishes VC to: %@", _currPlace.placeName);
    }
}

- (IBAction)segue:(id)sender {
//    DishesViewController *dishesVC = [[DishesViewController alloc] init];
//    dishesVC.place = _currPlace;
//    NSLog(@"Set the current place in Dishes VC to: %@", _currPlace.placeName);
//    NSLog(@"Dishes VC place from viewcontroller is: %@", dishesVC.place.placeName);
    [self performSegueWithIdentifier:@"Identifier" sender:self];
}
@end
