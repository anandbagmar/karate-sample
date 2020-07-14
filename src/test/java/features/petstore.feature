@pet
Feature: pet store

  Background:
    * url "https://petstore.swagger.io/v2/pet"

    * configure afterScenario =
    """
    function(){
      var info = karate.info;
      karate.log('afterScenario', info.scenarioType + ':', info.scenarioName);
    }
    """
    * def getPets =
    """
    {
  "http-request": {
    "method": "GET",
    "path": "/pets",
    "query": {
      "type": "dog",
      "status": "available",
      "name": "new"
    }
  },
  "http-response": {
    "status": 200,
    "body": [
      {
        "name": "Archie",
        "type": "dog",
        "status": "available",
        "id": 10
      },
      {
        "name": "Reggie",
        "type": "dog",
        "status": "available",
        "id": 20
      }
    ]
  }
}
    """

#  http://localhost:8080/_stub_setup

  @runtimestub
    Scenario: runtime cerate stub
    Given url 'http://localhost:8080/_stub_setup'
    And request getPets
    When method post
    Then status 200
    * print "stub created" + response

    Given url 'http://localhost:8080/pets'
    And param name = "new"
    And param status = "available"
    And param type = "dog"
    When method get
    Then status 200
    * print response




  @createpets
  Scenario: create a new pet
    Given url 'http://localhost:8080/pets'
    And request {'name': 'pup', 'type': 'dog', 'status': 'available'}
    When method put
    Then status 200
    * print response

  @single @get
  Scenario Outline: get multiple pet status
    Given path '/findByStatus'
    And param status = '<petStatus>,sold'
    When method get
    Then status 200
    And print response
    And print 'Number of pets: <petStatus>,sold - ' + response.length
    Examples:
      | petStatus |
      | available |
#      | available |
#      | sold      |
#      | available |
#      | available |
      | available |

  @multiple @get
  Scenario Outline: get pet status
    Given path '/findByStatus'
    And param status = '<petStatus>'
    When method get
    Then status 200
    And print response
    And print 'Number of pets: <petStatus> - ' + response.length
    Examples:
      | petStatus |
      | available |
      | pending   |
      | sold      |

  @put @pet
  Scenario: Find and update pet
    Given path '/findByStatus'
    And param status = 'available'
    When method get
    Then status 200
    And print response
    And print 'Number of pets: available - ' + response.length
    * def resp = response
    * def pet = resp[0]
    * print 'Pet chosen for update: ', pet
    * def id = pet.id
    * print 'id of pet available: ', id

    * def orgName = pet.name
    * def newName = pet.name + ' ' + pet.name
    * pet.name = newName
    * def tag1 = { name: '#(orgName)', id: #(id) }
    * def tag2 = { name: 'new name added', id: #(id) }
    * pet.tags = [tag1, tag2]

    Given path ''
    And request pet
    When method put
    Then status 200
    And def updatedPet = response
    * print 'updatedPet:', updatedPet

  @post
  Scenario: Create a new pet
    * def newPetInfo = read('newPet.json')
    * newPetInfo.name = newPetInfo.category.name
    * print newPetInfo
    Given request newPetInfo
    And method post
    Then status 200
    * print 'pet created: ', response

