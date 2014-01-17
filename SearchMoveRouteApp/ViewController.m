//
//  ViewController.m
//  SearchMoveRouteApp
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "TMapView.h"

#define APP_KEY @"7b7b1456-6496-3c3e-ae92-3cf87fd15065"
#define TOOLBAR_HIGHT 70

@interface ViewController ()<TMapViewDelegate>

@property (strong, nonatomic) TMapView *mapView;
@property (strong, nonatomic) TMapMarkerItem *startMarker, *endMarker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *transportType;

@end

@implementation ViewController

// 이동 방법 세그웨이 변경시

- (IBAction)transportTypeChanged:(id)sender {
    [self showPath];
}

-(void)showPath{
    TMapPathData *path = [[TMapPathData alloc] init];
    
    TMapPolyLine *line = [path findPathDataWithType:self.transportType.selectedSegmentIndex startPoint:[self.startMarker getTMapPoint] endPoint:[self.endMarker getTMapPoint]];
    
    if (nil != line) {
        [self.mapView showFullPath:@[line]];
        
        // 경로 안내선에 마커가 가리는 것을 방지
        [self.mapView bringMarkerToFront:self.startMarker];
        [self.mapView bringMarkerToFront:self.endMarker];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self showPath];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = CGRectMake(0, TOOLBAR_HIGHT, self.view.frame.size.width, self.view.frame.size.height - TOOLBAR_HIGHT);
    self.mapView = [[TMapView alloc] initWithFrame:rect];
    [self.mapView setSKPMapApiKey:APP_KEY];
    [self.view addSubview:self.mapView];
    
    // 시작 지점 마커
    self.startMarker = [[TMapMarkerItem alloc] init];
    [self.startMarker setIcon:[UIImage imageNamed:@"icon_clustering.png"]];
    TMapPoint *startPoint = [self.mapView convertPointToGpsX:50 andY:50];
    [self.startMarker setTMapPoint:startPoint];
    [self.mapView addCustomObject:self.startMarker ID:@"START"];
    
    // 종료 시점 마커
    self.endMarker = [[TMapMarkerItem alloc] init];
    [self.endMarker setIcon:[UIImage imageNamed:@"icon_clustering.png"]];
    TMapPoint *endPoint = [self.mapView convertPointToGpsX:300 andY:300];
    [self.endMarker setTMapPoint:endPoint];
    [self.mapView addCustomObject:self.endMarker ID:@"END"];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
