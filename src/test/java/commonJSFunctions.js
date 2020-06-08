function(config){
  config.findFirst = function(arr, key, value) {
                           for(var i=0; i<arr.length; i++) {
                             if(arr[i][key] === value) {
                               return arr[i];
                             }
                           }
                           throw new Error('Key ' + key  + ' Not found');
                       };

  config.getCurrentTimeInMillis = function(){
                                        return java.lang.System.currentTimeMillis()
                                  };
  config.generateRandomNumber = function(length){
                                           return Math.random().toFixed(length).split('.')[1];
                                 };
  return config;
}