Feature: context examples

  Background:
    * url "http://api.zippopotam.us/"

    * configure afterScenario =
    """
    function(){
      var info = karate.info;
      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
    }
    """

  @getlocation @template
  Scenario: get location & update value
    * print "in @getlocation"
    * print "passed in requestJson: " + requestJson
    * print "passed in updateEnv: " + updateEnv
    * def updateEnv = "new updateEnv value"
    * print "updated updateEnv: " + updateEnv
    Given path 'in/411006'
    When method get
    Then status 200
    And match response contains {'post code': '411006', 'country': 'India'}
    And print "response from get location: " + response

  @localcontext
  Scenario Outline: check conditional update of parameters - local context
    * print "in check conditional update of parameters"
    * print "default (from file): " + default
    * call read('classpath:features/common.feature@common')
    * def updateEnv = '<expectedEnv>' === 'default' ? 'matched' : <updatedEnv>
    * json requestJson5 = { "address": {"line1": "road 5", "city": "pune"}, "phone": [{"number": 12345}, {"number": 54321}]} }
    * print "number of phone numbers in json: " + numPhones(requestJson5.phone)
    * def Summary = call read('classpath:features/context.feature@getlocation') {requestJson: #(requestJson5), "updateEnv": #(updateEnv)}
    * print "back to main scenario"
    * print "response from get location: " + Summary
    * print "Current value of updateEnv: " + updateEnv
    * match updateEnv == <updatedEnv>
    Examples:
      | expectedEnv | updatedEnv  |
      | qa          | "next time" |

  @sharedcontext @failing
  Scenario Outline: check conditional update of parameters - shared context
    * print "in check conditional update of parameters"
    * print "default (from file): " + default
    * call read('classpath:features/common.feature@common')
    * def updateEnv = '<expectedEnv>' === 'default' ? 'matched' : <updatedEnv>
    * json requestJson5 = { "address": {"line1": "road 5", "city": "pune"}, "phone": [{"number": 12345}, {"number": 000}, {"number": 54321}]} }
    * print "number of phone numbers in json: " + numPhones(requestJson5.phone)
    * call read('classpath:features/context.feature@getlocation') {requestJson: #(requestJson5), "updateEnv": #(updateEnv)}
    * print "back to main scenario"
    * print "response from get location: " + response
    * print "Current value of updateEnv: " + updateEnv
    * match updateEnv == <updatedEnv>
    Examples:
      | expectedEnv | updatedEnv  |
      | qa          | "next time" |


  @mac
  Scenario: generate mac
    * def requestBody = {"a1": 1, "a2": {"a22": "a22", "a23": "b23"}, "a3": [{"a31": "a31"}, {"a32": "b32"}] }
    * call read('classpath:features/common.feature@common')
    * def generateMac =
  """
  function() {
    var GenerateMAC = Java.type('features.GenerateMAC');
    return new GenerateMAC().generate(arguments[0], arguments[1], arguments[2], arguments[3]);
  }
  """
    * def mac = generateMac("uuid", "randomNumber", "phoneNumber", requestBody)
    * print mac

  @commonfunctions
  Scenario Outline: call common functions from util.js
    * print "config.getCurrentTimeInMillis: " + getCurrentTimeInMillis()
    * print "config.generateRandomNumber(<length>): " + generateRandomNumber(<length>)
    Examples:
      | length |
      | 1      |
      | 2      |
      | 6      |
      | 10     |
      | 20     |
