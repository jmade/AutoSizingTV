//
//  ViewController.m
//  AutoSizingTV
//
//  Created by Justin Madewell on 8/17/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import "ViewController.h"
#import "JDMUtility.h"
#import "GeoPattern.h"

#import "JDMTableViewCell.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellData;
@property (nonatomic, strong) NSMutableArray *cellPictures;

@property (nonatomic, strong) UIImage *_image;


@property (nonatomic, strong) JDMTableViewCell *jdmCell;

@property (nonatomic, strong) dispatch_queue_t myQueue;



@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    _myQueue = dispatch_queue_create("myQueue", NULL);
    
    [self setupData];
    
    // doSomethingInBlock(13,@"Its my Block, Yo!");

    
    // Do any additional setup after loading the view, typically from a nib.
    [self constructTableView];
    
    
    
}

-(void)setupData
{
    NSLog(@"Data initialized");
    
    int r = randomInt(10, 25);
    
    // [self backgroundImages:r];
    self.cellData = [self generateCellLabels:r];

}

-(void)constructTableView
{
    
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView registerClass:[JDMTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellData.count;
}

#pragma mark - TableView Delegate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a reusable cell
    JDMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[JDMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [self.cellData objectAtIndex:indexPath.row];
    cell.imageView.image = [self.cellPictures objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.tableView.frame.size.height/4;
}



#pragma mark - TableViewCell



#pragma mark - Build Data Sources

-(NSArray*)generateCellLabels:(int)count
{
    self.cellPictures = [NSMutableArray array];
    
   NSMutableArray *myArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<count; i++) {
        NSString *text = [LoremIpsum sentencesWithNumber:randomInt(3, 5)];
        [myArray addObject:text];
        
        UIImage *image = [self createGeoPatternedImageOfSize:CGSizeMake(100, 150) withWord:[LoremIpsum word]];
        [self.cellPictures addObject:image];
        
    }
    
    return myArray;
}



-(UIImage*)makeGeoPatternImageFromString:(NSString*)string
{
    
    // Adds String and Hash to the options dictionary
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:string forKey:kGeoPatternString];
    [options setObject:[Helpers generateHash:string] forKey:kGeoPatternHash];
    CGSize size = [Pattern calculateSizeFromOptions:options];
    [options setObject:[NSValue valueWithCGSize:size] forKey:@"size"];
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0); // 0.0 = auto scale
    CGContextRef imgContext = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    
    UIColor *backgroundColor = [Helpers backgroundColor:options];
    CGContextSetFillColorWithColor(imgContext, backgroundColor.CGColor);
    CGContextFillRect(imgContext, rect);
    
    Pattern *pattern = [[Pattern alloc]
                        initWithContext:imgContext
                        WithOptions:options];
    [pattern generate];
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return patternImage;
}


//-(void)backgroundImages:(int)count
//{
//    self.cellPictures = [NSMutableArray array];
//    
//        for (int i=0; i<count; i++) {
//             [self.cellPictures addObject:[self threadsafeImage]];
//        }
//}


- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self setupData];
    
    
    [self.tableView reloadData];
    

    [refreshControl endRefreshing];
}


-(UIImage*)createGeoPatternedImageOfSize:(CGSize)size withWord:(NSString*)word
{
    NSString *string = word;
    
    CGSize imageSize = size;
    
    
    // Adds String and Hash to the options dictionary
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:string forKey:kGeoPatternString];
    [options setObject:[Helpers generateHash:string] forKey:kGeoPatternHash];
    CGSize patternSize = [Pattern calculateSizeFromOptions:options];
    [options setObject:[NSValue valueWithCGSize:patternSize] forKey:@"size"];
    
    
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0); // 0.0 = auto scale
    CGContextRef imgContext = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, patternSize.width, patternSize.height);
    
    
    UIColor *backgroundColor = [Helpers backgroundColor:options];
    CGContextSetFillColorWithColor(imgContext, backgroundColor.CGColor);
    CGContextFillRect(imgContext, rect);
    
    Pattern *pattern = [[Pattern alloc]
                        initWithContext:imgContext
                        WithOptions:options];
    [pattern generate];
    
    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGContextRef ctx = CGContextCreate(imageSize);
    UIColor *patternAsColor = [UIColor colorWithPatternImage:patternImage];
    CGContextSetFillColorWithColor(ctx, patternAsColor.CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage* image = UIGraphicsGetImageFromContext(ctx);
    CGContextRelease(ctx);
    
    
   return image;

}

//-(NSArray*)makeCellImages
//{
//    
//    NSString *string = [LoremIpsum word];
//    
//    CGSize imageSize = CGSizeMake(400, 600);
//    
//    
//    // Adds String and Hash to the options dictionary
//    NSMutableDictionary *options = [NSMutableDictionary dictionary];
//    [options setObject:string forKey:kGeoPatternString];
//    [options setObject:[Helpers generateHash:string] forKey:kGeoPatternHash];
//    CGSize size = [Pattern calculateSizeFromOptions:options];
//    [options setObject:[NSValue valueWithCGSize:size] forKey:@"size"];
//    
//    UIGraphicsBeginImageContextWithOptions(size, false, 0.0); // 0.0 = auto scale
//    CGContextRef imgContext = UIGraphicsGetCurrentContext();
//    
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    
//    
//    UIColor *backgroundColor = [Helpers backgroundColor:options];
//    CGContextSetFillColorWithColor(imgContext, backgroundColor.CGColor);
//    CGContextFillRect(imgContext, rect);
//    
//    Pattern *pattern = [[Pattern alloc]
//                        initWithContext:imgContext
//                        WithOptions:options];
//    [pattern generate];
//    
//    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    
//    
//    CGContextRef ctx = CGContextCreate(imageSize);
//    UIColor *patternAsColor = [UIColor colorWithPatternImage:patternImage];
//    CGContextSetFillColorWithColor(ctx, patternAsColor.CGColor);
//    CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
//    UIImage* image = UIGraphicsGetImageFromContext(ctx);
//    CGContextRelease(ctx);
//    
//    
//    image;
//    
//
//    return @[];
//
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


CG_INLINE CGContextRef CGContextCreate(CGSize size)
{
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(nil, size.width, size.height, 8, size.width * (CGColorSpaceGetNumberOfComponents(space) + 1), space, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(space);
    
    return ctx;
}

CG_INLINE UIImage* UIGraphicsGetImageFromContext(CGContextRef ctx)
{
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    UIImage* image = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    
    return image;
}


//#pragma mark - MY Block
//
//void (^doSomethingInBlock)(int, NSString*) = ^(int numberOfTimes,NSString* stringID){
//    
//    for (int i=0; i<numberOfTimes; i++) {
//        NSString *string = [NSString stringWithFormat:@"%@-%i",stringID,i];
//        NSLog(@"string:%@",string);
//        
//    }
//};
//
//
//
//
//


@end
