

extension StingParse on String {

  String toKey(){
    var writeKey = replaceAll(" ", "_");
    writeKey = writeKey.replaceAll("'", "");
    writeKey = writeKey.replaceAll(",", "_");
    writeKey = writeKey.replaceAll("，", "_");
    return writeKey;
  }
}