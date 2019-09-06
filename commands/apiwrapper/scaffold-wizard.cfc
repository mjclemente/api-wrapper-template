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
  * @package Create a box.json so this can be used as a Forgebox package (yes/no)
  */
  function run(
    required string apiName,
    required string apiEndpointUrl,
    required string apiAuthentication,
    required string apiDocUrl,
    required string name,
    required string description,
    required string author,
    boolean package = false
  ){
    // turn off wizard
    arguments.wizard = false;

    package = ask( 'Do you want to generate a box.json file, so this wrapper can be used and shared on ForgeBox? (Yes/No) : ' );

    if ( package == 'y' ) package = true;

    if ( !isBoolean( package ) )
      package = false;

    super.run( argumentCollection = arguments );
  }
}