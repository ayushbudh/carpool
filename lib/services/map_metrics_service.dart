  
  Future<String>? getDistanceInMiles(var directions) async {
    if (directions['distanceInMiles'] == "") {
      return "0 mi";
    }
    return directions['distanceInMiles'];
  }

  Future<String>? getDurationToReachDestination(var directions) async {
    if (directions['durationToReachDestination'] == "") {
      return "0 mi";
    }
    return directions['durationToReachDestination'];
  }