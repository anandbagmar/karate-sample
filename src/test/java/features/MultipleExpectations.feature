@payment
Feature: Payment related scenarios
  Background:
    * def requestBodyHeaders_v1 =
    """
    {
      "DeviceId": #(generateRandomNumber(15)),
      "Product":"2",
      "Version":"1.0",
      "RequestTime": #(generateRandomNumber(10)),
      "RequestId": #(generateRandomNumber(8))
    }
    """
    * def waitFor =
    """
      function(sec) {
        karate.log("wait for " + sec + " seconds");
        java.lang.Thread.sleep(sec * 1000)
      }

    """

  @foo
  Scenario Outline: When merchant clicks on Pay Now to pay for his order
    * call read('classpath:features/MultipleExpectations.feature@t_getRequest') { expectedStatus: <Status>, splitDetails: <SplitDetails>, purchaseId: <PurchaseId>, timeStamp: <TimeStamp>, version: <Version>, apiVersion: <ApiVersion>, expectedMessage: <Message> }
    And match response.Control.Message == <Message>
    Examples:
      | Status | Message        | SplitDetails                                          | PurchaseId  | TimeStamp        | Version | ApiVersion |
      | 200    | "Payment Info" | {"Amount":"0","MID":#(store.mid),"TID":#(store.tid)}  | "100477410" | "20200525184059" | "2.1"   | "2"        |
      | 200    | "new payment"  | {"Amount":"10","MID":#(store.mid),"TID":#(store.tid)} | "100477410" | "20200525184059" | "2.1"   | "2"        |

  @q_getRequest_expectations @template
  Scenario: Set expectations in Qontract for getRequest API call
    * json expectation = read('classpath:qontracts/getRequest.json')
    * set expectation.http-request.form-fields = getRequestData
    * set expectation.http-response.body.Data.MobileNumber = store.phoneNumber + ""
    * set expectation.http-response.body.Data.Customerid = store.phoneNumber + ""
    * print "updated expectation: " + expectation
    Given url "http://localhost:9000"
    And  path '/_qontract/expectations'
    And request expectation
    When method POST
    Then print "Response from _qontract/expectations: " + response
    * status 200
    * eval waitFor(2)

  @t_getRequest @template
  Scenario: When merchant clicks on Pay Now to pay for his order
    And def getRequestData =
    """
    {
      "Request": {
        "Body": {
          "Amount": "0",
          "IsEcomm": 1,
          "MobileNo": #(store.phoneNumber),
          "PurchaseDetails": null,
          "PurchaseId": #(purchaseId),
          "SplitDetails": [
              #(splitDetails)
          ],
          "SupplierId": #(supplier.id),
          "TimeStamp": #(timeStamp),
          "DeviceId": #(generateRandomNumber(15)),
          "POSTerminalId": #(store.posTerminalID),
          "PayMode": null,
          "Product": "2",
          "RequestTime":#(generateRandomNumber(10)),
          "StoreId": #(store.storeID),
          "Version": #(apiVersion),
          "CategoryId": null
        }
      }
    }
    """
    And set getRequestData.Request.Header = requestBodyHeaders_v1
    And print "getRequestData: " + getRequestData
    * call read('classpath:features/MultipleExpectations.feature@q_getRequest_expectations') { getRequestData: #(getRequestData) }

    Given url "http://localhost:9000"
    And path '/Order/Payment/getRequest'
    And form field Data = getRequestData
    When method POST
    * print "Response from getRequest: " + response
    Then match responseStatus == expectedStatus
    * eval waitFor(2)
