enum ExpenseCategory {
  fuel('Fuel'),
  service('Service'),
  repairs('Repairs'),
  insurance('Insurance'),
  licensing('Licensing/Registration'),
  tires('Tires'),
  parkingTolls('Parking/Tolls'),
  carWash('Car Wash'),
  other('Other');

  const ExpenseCategory(this.label);

  final String label;
}
