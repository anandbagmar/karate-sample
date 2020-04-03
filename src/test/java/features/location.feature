@location
Feature: location

  Background:
    * url "http://api.zippopotam.us/"

  @single @get
  Scenario: get location in India
    Given path 'in/411006'
    When method get
    Then status 200
    And match response contains {'post code': '411006', 'country': 'India'}

  @multiple @get
  Scenario Outline: get locations across the globe
    * def query = { postcode: '<postcode>', country: '<country>',expectedPlaceName:'<expectedPlaceName>', expectedCountry:'<expectedCountry>' }
    Given path '<country>/<postcode>'
    When method get
    Then status 200
    And match response contains {'post code': '<postcode>', 'country': '<expectedCountry>'}
    And match response.places[0].['place name'] == '<expectedPlaceName>'
    And match response.places == '#[<expectedPlaces>]'
    Examples:
      | postcode | country | expectedPlaceName | expectedCountry | expectedPlaces |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath           | India           | 19             |
      | 90210    | us      | Beverly Hills     | United States   | 1              |
     