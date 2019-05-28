void main() {
  PowerGrid grid = new PowerGrid();
  NuclearPlant nuclear = new NuclearPlant();
  SolarPlant solar = new SolarPlant();

  grid.addPlant(nuclear);
  grid.addPlant(solar);
}

class PowerGrid {
  List<PowerPlant> connectedPlants = [];

  addPlant(PowerPlant plant) {
    bool confirmation = plant.turnOn('5 hours');
    connectedPlants.add(plant);
  }
}

abstract class PowerPlant {
  int costOfEnergy;

  bool turnOn(String duration);
}

class NuclearPlant implements PowerPlant {
  int costOfEnergy;

  bool turnOn(String timeToStayOn) {
    print('I am a nuclear plant turning on');
    return true;
  }

  meltDown() {
    print('BLOWS UP!!!');
  }
}

class SolarPlant implements PowerPlant {
  int costOfEnergy;

  bool turnOn(String howLongOn) {
    print('I am a solar plant turning on');
    return false;
  }
}
