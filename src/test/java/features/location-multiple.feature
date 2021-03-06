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

  @India @multiple @get
  Scenario Outline: get locations across the India
    * def query = { postcode: '<postcode>', country: '<country>',expectedPlaceName:'<expectedPlaceName>', expectedCountry:'<expectedCountry>' }
    Given path '<country>/<postcode>'
    When method get
    Then status 200
    And match response contains {'post code': '<postcode>', 'country': '<expectedCountry>'}
    And match response.places[0].['place name'] == '<expectedPlaceName>'
    And match response.places == '#[<expectedPlaces>]'
    And print response
    Examples:
      | postcode | country | expectedPlaceName | expectedCountry | expectedPlaces |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath1          | India           | 19             |
      | 411006   | in      | Yerwada           | India           | 3              |
      | 110001   | in      | Janpath           | India           | 19             |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath           | India           | 19             |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath           | India           | 20             |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath           | India           | 19             |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath           | India           | 19             |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath           | India           | 19             |
      | 411006   | in      | Yerwada           | India           | 2              |
      | 110001   | in      | Janpath           | India           | 19             |

  @multiple @get @USA
  Scenario Outline: get locations across the globe
    * def query = { postcode: '<postcode>', country: '<country>',expectedPlaceName:'<expectedPlaceName>', expectedCountry:'<expectedCountry>' }
    Given path '<country>/<postcode>'
    When method get
    Then status 200
    And match response contains {'post code': '<postcode>', 'country': '<expectedCountry>'}
    And match response.places[0].['place name'] == '<expectedPlaceName>'
    And match response.places == '#[<expectedPlaces>]'
    And print response
    Examples:
      | postcode | country | expectedPlaceName | expectedCountry | expectedPlaces |
      | 90210    | us      | Beverly Hills     | United States   | 1              |
      | 95036    | us      | Milpitas          | United States   | 2              |
      | 02478    | us      | Belmont           | United States   | 1              |
      | 90210    | us      | Beverly Hills     | United States   | 1              |
      | 95236    | us      | Milpitas          | United States   | 3              |
      | 02478    | us      | Belmont           | United States   | 1              |
      | 90210    | us      | Beverly Hills     | United States   | 3              |
      | 95036    | us      | Milpitas          | United States   | 2              |
      | 02678    | us      | Belmont           | United States   | 1              |
      | 90210    | us      | Beverly Hills     | United States   | 5              |
      | 95036    | us      | Milpitas          | United States   | 1              |
      | 02478    | us      | Belmont           | United States   | 1              |
