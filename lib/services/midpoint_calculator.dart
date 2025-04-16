import 'dart:math' as math;
import '../models/location_model.dart';

class MidpointCalculator {
  // Calculate the geographic midpoint between two locations
  // Uses the Haversine formula to account for Earth's curvature
  static Location calculateGeographicMidpoint(Location locationA, Location locationB) {
    // Convert latitude and longitude from degrees to radians
    final lat1 = _degreesToRadians(locationA.latitude);
    final lon1 = _degreesToRadians(locationA.longitude);
    final lat2 = _degreesToRadians(locationB.latitude);
    final lon2 = _degreesToRadians(locationB.longitude);

    // Convert to Cartesian coordinates
    final x1 = math.cos(lat1) * math.cos(lon1);
    final y1 = math.cos(lat1) * math.sin(lon1);
    final z1 = math.sin(lat1);

    final x2 = math.cos(lat2) * math.cos(lon2);
    final y2 = math.cos(lat2) * math.sin(lon2);
    final z2 = math.sin(lat2);

    // Calculate the midpoint in Cartesian coordinates
    final x = (x1 + x2) / 2;
    final y = (y1 + y2) / 2;
    final z = (z1 + z2) / 2;

    // Convert back to spherical coordinates
    final lon = math.atan2(y, x);
    final hyp = math.sqrt(x * x + y * y);
    final lat = math.atan2(z, hyp);

    // Convert back to degrees
    final midpointLat = _radiansToDegrees(lat);
    final midpointLon = _radiansToDegrees(lon);

    return Location(
      name: 'Midpoint',
      latitude: midpointLat,
      longitude: midpointLon,
    );
  }

  // Calculate the weighted midpoint based on travel time
  // This is a simplified version that adjusts the midpoint based on a weight factor
  static Location calculateWeightedMidpoint(
    Location locationA, 
    Location locationB, 
    double weightA, 
    double weightB
  ) {
    // Normalize weights
    final totalWeight = weightA + weightB;
    final normalizedWeightA = weightA / totalWeight;
    final normalizedWeightB = weightB / totalWeight;

    // Convert to radians
    final lat1 = _degreesToRadians(locationA.latitude);
    final lon1 = _degreesToRadians(locationA.longitude);
    final lat2 = _degreesToRadians(locationB.latitude);
    final lon2 = _degreesToRadians(locationB.longitude);

    // Convert to Cartesian coordinates
    final x1 = math.cos(lat1) * math.cos(lon1);
    final y1 = math.cos(lat1) * math.sin(lon1);
    final z1 = math.sin(lat1);

    final x2 = math.cos(lat2) * math.cos(lon2);
    final y2 = math.cos(lat2) * math.sin(lon2);
    final z2 = math.sin(lat2);

    // Calculate the weighted midpoint
    final x = x1 * normalizedWeightB + x2 * normalizedWeightA;
    final y = y1 * normalizedWeightB + y2 * normalizedWeightA;
    final z = z1 * normalizedWeightB + z2 * normalizedWeightA;

    // Convert back to spherical coordinates
    final lon = math.atan2(y, x);
    final hyp = math.sqrt(x * x + y * y);
    final lat = math.atan2(z, hyp);

    // Convert back to degrees
    final midpointLat = _radiansToDegrees(lat);
    final midpointLon = _radiansToDegrees(lon);

    return Location(
      name: 'Weighted Midpoint',
      latitude: midpointLat,
      longitude: midpointLon,
    );
  }

  // Calculate the distance between two locations in kilometers
  static double calculateDistance(Location locationA, Location locationB) {
    const earthRadius = 6371.0; // Earth's radius in kilometers
    
    final lat1 = _degreesToRadians(locationA.latitude);
    final lon1 = _degreesToRadians(locationA.longitude);
    final lat2 = _degreesToRadians(locationB.latitude);
    final lon2 = _degreesToRadians(locationB.longitude);

    // Haversine formula
    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
              math.cos(lat1) * math.cos(lat2) * 
              math.sin(dLon / 2) * math.sin(dLon / 2);
              
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = earthRadius * c;
    
    return distance;
  }

  // Helper method to convert degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  // Helper method to convert radians to degrees
  static double _radiansToDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }
}
