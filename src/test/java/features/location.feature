@location
Feature: location

  Background:
    * url "http://api.zippopotam.us/"

    * configure afterScenario =
    """
    function(){
      var info = karate.info;
      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
    }
    """

  @single @get @India
  Scenario: get location in Pune, India
    Given path 'in/411006'
    When method get
    Then status 200
    And match response contains {'post code': '411006', 'country': 'India'}
    And print response

  @USA @single @get
  Scenario: get location in USA
    Given path 'us/90210'
    When method get
    Then status 200
    And match response contains {'post code': '90210', 'country': 'United States'}
    And print response

  @single @get @India
  Scenario: get location in Delhi, India
    Given path 'in/110001'
    When method get
    Then status 200
    And match response contains {'post code': '110001', 'country': 'India'}
    And print response
