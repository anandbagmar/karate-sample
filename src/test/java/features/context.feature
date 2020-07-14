Feature: context examples

  Background:
    * url "http://api.zippopotam.us/"
    * callonce read('classpath:features/common.feature@common')
    * print "token: background: " + token

    * configure afterScenario =
    """
    function(){
      var info = karate.info;
      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
    }
    """

  @template_getlocation @template @foo
  Scenario: get location & update value
    * print "in @template_getlocation"
    * print "passed in requestJson: " + requestJson
    * print "passed in updateEnv: " + updateEnv
    * def updateEnv = "new updateEnv value"
    * print "updated updateEnv: " + updateEnv
    Given path 'in/411006'
    When method get
    Then status 200
    And match response contains {'post code': '411006', 'country': 'India'}
    And print "response from get location: " + response

  @template_localcontext @template
  Scenario Outline: check conditional update of parameters - local context
    * print "in check conditional update of parameters"
    * print "default (from file): " + default
    * call read('classpath:features/common.feature@common')
    * def updateEnv = '<expectedEnv>' === 'default' ? 'matched' : <updatedEnv>
    * json requestJson5 = { "address": {"line1": "road 5", "city": "pune"}, "phone": [{"number": 12345}, {"number": 54321}]} }
    * print "number of phone numbers in json: " + numPhones(requestJson5.phone)
    * def Summary = call read('classpath:features/context.feature@template_getlocation') {requestJson: #(requestJson5), "updateEnv": #(updateEnv)}
    * print "back to main scenario"
    * print "response from get location: " + Summary
    * print "Current value of updateEnv: " + updateEnv
    * match updateEnv == <updatedEnv>
    * call read('classpath:features/context.feature@template_localcontext')
    Examples:
      | expectedEnv | updatedEnv  |
      | qa          | "next time" |

  @sharedcontext @failing @template
  Scenario Outline: check conditional update of parameters - shared context
    * print "in check conditional update of parameters"
    * print "default (from file): " + default
    * call read('classpath:features/common.feature@common')
    * def updateEnv = '<expectedEnv>' === 'default' ? 'matched' : <updatedEnv>
    * json requestJson5 = { "address": {"line1": "road 5", "city": "pune"}, "phone": [{"number": 12345}, {"number": 000}, {"number": 54321}]} }
    * print "number of phone numbers in json: " + numPhones(requestJson5.phone)
    * call read('classpath:features/context.feature@template_getlocation') {requestJson: #(requestJson5), "updateEnv": #(updateEnv)}
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
    * def mac = generateMac("uuid", "randomNumber", "phoneNumber", requestBody)
    * print "generated mac: " + mac

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

  @tokenoptimization @token
  Scenario Outline: token optimization4
    * print "token optimization4: " + token
    Examples:
      | length |
      | 1      |

  @tokenoptimization @token
  Scenario Outline: token optimization5
    * print "token optimization5: " + token
    * def newToken =  call read('classpath:features/common.feature@token')
    * def token = newToken.newToken

    * print "token optimization5: new token: " + token
    Examples:
      | length |
  | 1      |

