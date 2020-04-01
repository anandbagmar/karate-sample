@pet
Feature: pet store

  Background:
    * url "https://petstore.swagger.io/v2/pet/"

  @single
  Scenario Outline: get multiple pet status
    Given path 'findByStatus'
    And param status = '<petStatus>,sold'
    When method get
    Then status 200
    And print 'Number of pets: <petStatus>,sold - ' + response.length
    Examples:
      | petStatus |
      | available |

  @multiple
  Scenario Outline: get pet status
    Given path 'findByStatus'
    And param status = '<petStatus>'
    When method get
    Then status 200
    And print 'Number of pets: <petStatus> - ' + response.length
    Examples:
      | petStatus |
      | available |
      | pending   |
      | sold      |
