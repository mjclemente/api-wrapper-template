/**
* Create a new API Client Wrapper
* This command will create a folder in the current working directory and generate the basic files needed to begin developing a new API wrapper. 
* 
* Once installed, you can run the command using the --wizard parameter for a walkthrough of all options that can be configured
* 
* {code:bash}
* apiwrapper scaffold --wizard
* {code}
*
* You can set global defaults for author in the module settings.
* Then you don't need to pass those parameters in to `apiwrapper scaffold`.
*
* {code:bash}
* config set modules.api-wrapper-template.author="Matthew J. Clemente"
* {code}
*/
component {

  property name="moduleSettings" inject="commandbox:moduleSettings:api-wrapper-template";
  property name="system" inject="system@constants";

  variables.templatePath = "/api-wrapper-template/template/";

  /**
  * @apiName Name of the API this library will wrap. [i.e. Stripe]
  * @apiEndpointUrl Base endpoint URL for API calls. [i.e. https://api.stripe.com/v1]
  * @apiDocUrl URL of the API documentation homepage
  * @name Name for the wrapper [i.e. StripeCFC]
  * @description A short description of the wrapper.
  * @author Name of the author of the wrapper.
  * @wizard Run the init wizard, defaults to false
  * @quickStart After scaffolding, cd into project and start server [defaults to false]
  */
  function run (
    string apiName = "",
    string apiEndpointUrl = "",
    string apiDocUrl = '',
    string name = '',
    string description = '',
    string author,
    boolean wizard = false,
    boolean quickStart = false ) {
    
    if ( wizard ) {
      command( 'apiwrapper scaffold-wizard' ).run();
      return;
    }

    if ( !apiName.trim().len() ) {

      print.line()
        .boldRedLine( "In order to scaffold this wrapper, you need to provide the name of the API you're working with." )
        .redLine( "(Otherwise we really would know what we were scaffolding.)" )
        .line();

      apiName = trim( ask( 'What is the name of the API this library will wrap. [i.e. Stripe]: ' ) );

      if ( !apiName.len() ) {
        print.line( 'Ok, exiting. You can run the wizard, or provide the apiName argument when scaffolding your wrapper.' );
        return;
      } else {
        print.greenLine( "Thanks! On with the show! " )
          .line();
      }
    }

    if ( !apiEndpointUrl.trim().len() ) {

      print.line()
        .boldRedLine( "In order to scaffold this wrapper, you need to provide the base endpoint URL for API calls." )
        .redLine( "(If you don't have it, go look it up right now. We need an endpoint to make our API calls.)" )
        .line();

      apiEndpointUrl = trim( ask( 'What is the base endpoint URL for API calls. [i.e. https://api.stripe.com/v1]: ' ) );
      if( !apiEndpointUrl.len() ) {
        print.line( 'Ok, exiting. You can run the wizard, or provide the apiEndpointUrl argument when scaffolding your wrapper.' );
        return;
      } else {
        print.greenLine( "Thanks! On with the show! " )
          .line();
      }

    }

    name = name.trim().len() ? name : apiName.lcase() & 'cfc';
    author = author ?: moduleSettings.author;

    for ( var arg in arguments ) {
      print.magentaLine( '- Set #arg# = #arguments[ arg ]#' );
    }
    print.line();

    //let's print some warnings, if the data doesn't look right
    if ( !isValid( 'url', apiEndpointUrl ) )
      print.yellowLine( "Warning: The apiEndpointUrl does not appear to be valid. This could cause issues." );
    if ( !apiDocUrl.len() )
      print.yellowLine( "Warning: You didn't include an apiDocUrl. Consider linking to the API documentation in the README." );
    else if ( apiDocUrl.len() && !isValid( 'url', apiDocUrl ) )
      print.yellowLine( "Warning: The apiDocUrl does not appear to be valid, which could result in some confusing documentation." );
    if ( !description.len() )
      print.yellowLine( "Warning: You didn't include a description. Considering adding an explanation of what your wrapper does in the README." );
    if ( !author.len() )
      print.yellowLine( "Warning: The author name is blank... don't you want credit for your work?" );

    //let's create the extra variables that we need
    var substitutions = {
      'name' : name,
      'author' : author,
      'apiEndpointUrl' : apiEndpointUrl,
      'description' : description,
      'apiNameSlug' : toProperFileName( apiName ),
      'copyright' : ( author.len() ? '#author#,' : '' ) & ' Matthew J. Clemente, John Berquist',
      'copyrightYear' : now().year(),
      'apiReference' : apiDocUrl.len() ? '[#apiName# API](#apiDocUrl#)' : '#apiName# API'
    }

    var projectDirectory = fileSystemUtil.resolvePath( '#substitutions.apiNameSlug#Wrapper' );
    var wrapperDirectory = projectDirectory & '/#substitutions.apiNameSlug#';

    print.line().boldCyanLine( "Copying template over...." ).toConsole();

    if ( !directoryExists( projectDirectory ) )
      directoryCreate( projectDirectory );
    if ( !directoryExists( wrapperDirectory ) )
      directoryCreate( wrapperDirectory );

    var serverJson = fileRead( templatePath & "server.json.stub" );
    fileWrite( projectDirectory & "/server.json", serverJson );

    var index = fileRead( templatePath & "index.cfm.stub" );
    substitutions.each( 
      function( key, value ) {
        index = index.replaceNoCase( '@@#key#@@', value, 'all' );
      }
    );
    fileWrite( projectDirectory & "/index.cfm", index );

    var readme = fileRead( templatePath & "README.md.stub" );
    substitutions.each( 
      function( key, value ) {
        readme = readme.replaceNoCase( '@@#key#@@', value, 'all' );
      }
    );
    fileWrite( wrapperDirectory & "/README.md", readme );

    var license = fileRead( templatePath & "LICENSE.stub" );
    substitutions.each( 
      function( key, value ) {
        license = license.replaceNoCase( '@@#key#@@', value, 'all' );
      }
    );
    fileWrite( wrapperDirectory & "/LICENSE", license );

    var template  = fileRead( templatePath & "template.cfc.stub" );
    substitutions.each( 
      function( key, value ) {
        template = template.replaceNoCase( '@@#key#@@', value, 'all' );
      }
    );
    fileWrite( wrapperDirectory & "/#substitutions.apiNameSlug#.cfc", template );

    print.line()
      .greenLine( "Success! Your API wrapper is scaffolded!" )
      .line();

    if ( quickStart ) {
    
      print.line( "Changing directory to project folder..." );
      command( 'cd #projectDirectory#' ).run();

      print.line( "Starting a server, so you can start developing right away!" );
      command( 'server start' ).run();
    
    } else {
      print.line( "Now it's time to CD into the directory and start developing!" );
    }

    print.line().line();
  }


  /**
  * Modified version of https://cflib.org/udf/toFriendlyURL by Chris Carey (ccarey@fi.net.au)
  */
  public string function toProperFileName( string str ) {

    var diacritics = [
      ["#CHR(225)##CHR(224)##CHR(226)##CHR(229)##CHR(227)##CHR(228)#", "a"],
      ["#CHR(230)#", "ae"],
      ["#CHR(231)#", "c"],
      ["#CHR(233)##CHR(232)##CHR(234)##CHR(235)#", "e"],
      ["#CHR(237)##CHR(236)##CHR(238)##CHR(239)#", "i"],
      ["#CHR(241)#", "n"],
      ["#CHR(243)##CHR(242)##CHR(244)##CHR(248)##CHR(245)##CHR(246)#", "o"],
      ["#CHR(223)#", "B"],
      ["#CHR(250)##CHR(249)##CHR(251)##CHR(252)#", "u"],
      ["#CHR(255)#", "y"],
      ["#CHR(193)##CHR(192)##CHR(194)##CHR(197)##CHR(195)##CHR(196)#", "A"],
      ["#CHR(198)#", "AE"],
      ["#CHR(199)#", "C"],
      ["#CHR(201)##CHR(200)##CHR(202)##CHR(203)#", "E"],
      ["#CHR(205)##CHR(204)##CHR(206)##CHR(207)#", "I"],
      ["#CHR(209)#", "N"],
      ["#CHR(211)##CHR(210)##CHR(212)##CHR(216)##CHR(213)##CHR(214)#", "O"],
      ["#CHR(218)##CHR(217)##CHR(219)##CHR(220)#", "U"]
    ];

    str = diacritics.reduce(
      function( result, item, index ) {
        return result.ReReplace( item[1], item[2], "all" );
      }, str
    );

    // make it all lower case (and adjust length)
    str = str.trim().lcase().left( 127 );
    // replace consecutive spaces and dashes and underscores with a single dash
    str = str.ReReplace( '[\s\-_]{1,}', '-', 'all' );
    // replace ampersand with and
    str = str.ReReplace( '&amp;', 'and', 'all' );
    str = str.ReReplace( '&.*?;', '', 'all' );
    str = str.ReReplace( '&', 'and', 'all' );

    // remove any remaining non-word chars
    str = str.ReReplace( '[^a-zA-Z0-9\-\_]', '', 'all' );

    // remove dashes at the beginning or end of the string
    str = str.ReReplace( '(^\-+)|(\-+$)', '', 'all' );
    //remove dots at the beginning or end of the string
    str = ReReplace(str, '(^\.+)|(\.+$)', '', 'all');

    return str;
  }

}
