//
//  DishesViewController.m
//  Dishcovery
//
//  Created by Gargium on 12/27/15.
//  Copyright © 2015 Gargium. All rights reserved.
//

#import "DishesViewController.h"

@interface DishesViewController () <UIAlertViewDelegate, UITableViewDelegate>

//pass in a places object and use its dishes array instead
//@property (nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property UIColor *prettyPurple;
@property UIColor *goodDishColor;
@property UIColor *badDishColor;


@end

@implementation DishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"place name from dishes vc: %@", _place.placeName); 
    //self.items = @[@{@"name": @"tiramisu", @"category": @"Home"}].mutableCopy;
    self.navigationItem.title = @"Dishes";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(goBackToMain:)];
    NSString *name =_place.placeName;
    self.navigationItem.prompt = [NSString stringWithFormat:@"Editing dishes for %@", name] ;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setMultipleTouchEnabled:YES];
    
    //set colors
    _prettyPurple = [UIColor colorWithRed:142/255.0 green:68/255.0 blue:173/255.0 alpha:1];
    _goodDishColor = [UIColor colorWithRed:156/255.0 green:240/255.0 blue:185/255.0 alpha:1];
    _badDishColor = [UIColor colorWithRed:240/255.0 green:156/255.0 blue:187/255.0 alpha:1];
    
    //self.tableView.backgroundColor = [UIColor purpleColor];
    [self.view setBackgroundColor:_prettyPurple];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}


- (void) goBackToMain: (UIBarButtonItem *) sender {
    [self performSegueWithIdentifier:@"goBackToMain" sender:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Adding Items
- (void) addNewItem:(UIBarButtonItem *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Dish"
                                                        message:@"Please enter your dish" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"add new item", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        UITextField *itemNameField = [alertView textFieldAtIndex:0];
        NSString *itemName = itemNameField.text;
//        NSDictionary *item = @{@"name": itemName, @"category" : @"Home"};
//        [self.items addObject:item];
        [_place.dishes addObject:itemName];
        [self.tableView reloadData]; 
//        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count -1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_place.dishes.count-1) inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - Table view datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.items.count;
    return _place.dishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TodoItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    NSDictionary *item = self.items[indexPath.row];
//    cell.textLabel.text = item[@"name"];
    cell.textLabel.text = _place.dishes[indexPath.row];
    [cell setBackgroundColor:_goodDishColor];

    UIView *bgColorView = [[UIView alloc] init];
    if (cell.backgroundColor != _goodDishColor) [bgColorView setBackgroundColor:_goodDishColor];
    else [bgColorView setBackgroundColor:_badDishColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13];
    return cell;
    
}

@end
