
#import "GoogleMaps.h"
#import "TSLocationSearchViewController.h"
#import "TSConstants.h"

@interface TSLocationSearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSTimer *searchTimer;
@end

@implementation TSLocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupSearchBar];
    [self setupTapGesture];
}

#pragma mark - Table View Data Source

- (void) setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCellReuseID" forIndexPath:indexPath];
    
    cell.textLabel.attributedText = self.searchResults[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *newLocation = [((NSAttributedString *)self.searchResults[indexPath.row]) string];
    
    [self.delegate updateWeatherWithLocation:newLocation];
}

#pragma mark - Search Bar

- (void) setupSearchBar {
    self.searchResults = [NSMutableArray new];
    self.searchBar.delegate = self;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.searchBar becomeFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (!self.searchTimer) {
        self.searchTimer = [[NSTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:1] interval:0 target:self selector:@selector(googlePlacesSearch) userInfo:nil repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:self.searchTimer forMode:NSDefaultRunLoopMode];
        
    } else {
        self.searchTimer.fireDate = [[NSDate date] dateByAddingTimeInterval:0.5];
    }
}

- (void) googlePlacesSearch {
    
    GMSPlacesClient *client = [[GMSPlacesClient alloc] init];
    
    [client autocompleteQuery:self.searchBar.text bounds:nil filter:nil callback:^(NSArray *results, NSError *error) {
        
        if (results) {
            
            [self.searchResults removeAllObjects];
            
            for (GMSAutocompletePrediction *location in results) {
                [self.searchResults addObject:location.attributedFullText];
            }
            
            [self.tableView reloadData];
        }
        
        self.searchTimer = nil;
    }];
}

#pragma mark - Tap Gesture

- (void) setupTapGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC)];
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
}

- (void) dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Misc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
