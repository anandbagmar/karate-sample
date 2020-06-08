Feature: Common utility functions

  @ignore @common
  Scenario: Common Scenario
    * def numPhones = function(jsonArray){ return jsonArray.length; }
    * def generateMac =
  """
  function() {
    var GenerateMAC = Java.type('features.GenerateMAC');
    return new GenerateMAC().generate(arguments[0], arguments[1], arguments[2], arguments[3]);
  }
  """
