@pet
Feature: pet store

  Background:
    * url "https://petstore.swagger.io/v2/pet"

  @single @get
  Scenario Outline: get multiple pet status
    Given path '/findByStatus'
    And param status = '<petStatus>,sold'
    When method get
    Then status 200
    And print 'Number of pets: <petStatus>,sold - ' + response.length
    Examples:
      | petStatus |
      | available |

  @multiple @get
  Scenario Outline: get pet status
    Given path '/findByStatus'
    And param status = '<petStatus>'
    When method get
    Then status 200
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
    And print 'Number of pets: available - ' + response.length
    * def resp = response
    * def pet = resp[0]
    * print 'Pet chosen for update: ', pet
    * def id = pet.id
    * print 'id of pet available: ', id

    * def orgName = pet.name
    * def newName = pet.name + ' ' + pet.name
#      * print orgName
#      * print newName
    * pet.name = newName
    * def tag1 = { name: '#(orgName)', id: #(id) }
    * def tag2 = { name: 'new name added', id: #(id) }
#      * print tag1
#      * print tag2
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
    And def resp = response
    * print 'pet created: ', resp

