function fn() {   
  var env = karate.env; // get system property 'karate.env'
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    testConfig: 'bar'
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  var port = karate.properties['karate.server.port'];
  port = port || '8080';
  config.mockServerUrl = 'http://localhost:' + port + '/v1/';
  karate.log("Environment: " + env);
  return config;
}