#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
  IKMapLocationDevice,
  IKMapLocationCurrentPosition,
  IKMapLocationHomePosition,
  IKMapLocationTargetPosition,
  IKMapLocationWayPoint,
  IKMapLocationPOI
  } IKMapLocationType;

@interface MapLocation : NSObject <MKAnnotation, NSCoding> {
  IKMapLocationType type;
  CLLocationCoordinate2D coordinate;
}
@property (nonatomic, assign) IKMapLocationType type;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@end
