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
#    * def random = generateRandomNumber(10)
#    * def newToken = updateToken(random)
#    * def token = isTokenValid("generatedToken") ? getCreatedToken : newToken

  @token @ignore
  Scenario: Generate token
    * def newToken = generateRandomNumber(10)
    * print "Generate token: " + newToken
