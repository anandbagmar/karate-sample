Feature: context examples

  Background:
    * url "http://api.zippopotam.us/"
    * callonce read('classpath:features/common.feature@common')
    * print "token: background: " + token
    * def newToken =  callonce read('classpath:features/common.feature@token')
    * def token = newToken.newToken
    * print "token: background: updated token " + token
#    * configure afterScenario =
#    """
#    function(){
#      var info = karate.info;
#      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
#    }
#    """

  @mac @token
  Scenario: generate mac
    * def requestBody = {"a1": 1, "a2": {"a22": "a22", "a23": "b23"}, "a3": [{"a31": "a31"}, {"a32": "b32"}] }
    * def mac = generateMac("uuid", "randomNumber", "phoneNumber", requestBody)
    * print "generated mac: " + mac
    * print "generated mac: token: " + token
    * def newToken =  call read ('classpath:features/common.feature@token')
    * def token = newToken.newToken
    * print "generated mac: new token: " + token

  @tokenoptimization @token
  Scenario Outline: token optimization1
    * print "token optimization1: " + token
    Examples:
      | length |
      | 1      |
#      | 2      |

  @tokenoptimization @token
  Scenario Outline: token optimization2
    * print "token optimization2: " + token
    * def newToken =  call read('classpath:features/common.feature@token')
    * def token = newToken.newToken
    * print "token optimization2: new token: " + token
    Examples:
      | length |
  | 1      |
#      | 2      |

