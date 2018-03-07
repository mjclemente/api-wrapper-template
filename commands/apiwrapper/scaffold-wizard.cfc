/**
 * Walk the user through creating their wrapper using our lovely wizard
 **/
component extends="scaffold" excludeFromHelp=false {

  /**
  * @apiName Name of the API this library will wrap. [i.e. Stripe]
  * @apiEndpointUrl Base endpoint URL for API calls. [i.e. https://api.stripe.com/v1]
  * @apiDocUrl URL of the API documentation homepage
  * @name Name for the wrapper [i.e. StripeCFC]
  * @description A short description of the wrapper.
  * @author Name of the author of the wrapper.
  */
  function run(
    required string apiName,
    required string apiEndpointUrl,
    required string apiDocUrl,
    required string name,
    required string description,
    required string author
  ){
    // turn off wizard
    arguments.wizard = false;
    super.run( argumentCollection = arguments );
  }
}