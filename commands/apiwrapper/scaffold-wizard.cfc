/**
 * Walk the user through creating their wrapper using our lovely wizard
 **/
component extends="scaffold" excludeFromHelp=false {

  /**
  * @apiName Name of the API this library will wrap. [i.e. Stripe]
  * @apiEndpointUrl Base endpoint URL for API calls. [i.e. https://api.stripe.com/v1]
  * @apiAuthentication.hint Type of authentication used [None, Basic, Apikey, Other]
  * @apiAuthentication.optionsUDF completeAuthentication
  * @apiDocUrl URL of the API documentation homepage
  * @name Name for the wrapper [i.e. StripeCFC]
  * @description A short description of the wrapper.
  * @author Name of the author of the wrapper.
  */
  function run(
    required string apiName,
    required string apiEndpointUrl,
    required string apiAuthentication,
    required string apiDocUrl,
    required string name,
    required string description,
    required string author,
    boolean quickStart = false
  ){
    // turn off wizard
    arguments.wizard = false;

    quickStart = ask( 'Do you want to quickStart the project? (After scaffolding, cd into project and start server [defaults to false]): (Yes/No) : ' );

    if ( quickStart == 'y' ) quickStart = true;

    if ( !isBoolean( quickStart ) )
      quickStart = false;

    super.run( argumentCollection = arguments );
  }
}