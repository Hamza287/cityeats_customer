Map<String, String> vendorTypes = <String, String>{
  'SM': 'Small',
  'MD': 'Medium',
  'LG': 'Large'
};
String getSizeName(String label) {
  switch (label) {
    case "SM":
      return "Small";
    case "MD":
      return "Medium";
    case "LG":
      return "Large";
    default:
      return "null";
  }
}
