function fn() {   
  var env = karate.env; // get system property 'karate.env'
  if (!env) {
    env = 'qa';
  }
  var testDataConfig = read('classpath:test_data.json');
  var port = karate.properties['karate.server.port'];
  port = port || '8080';
  testDataConfig.mockServerUrl = 'http://localhost:' + port + '/v1/';
  karate.log("Environment: " + env);
  var loadedValues = karate.callSingle('commonJSFunctions.js', testDataConfig[env]);
  return loadedValues;
}