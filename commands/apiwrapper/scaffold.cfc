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
  * @apiAuthentication.hint Type of authentication used [None, Basic, Apikey, Other]
  * @apiAuthentication.optionsUDF completeAuthentication
  * @apiDocUrl URL of the API documentation homepage
  * @name Name for the wrapper [i.e. StripeCFC]
  * @description A short description of the wrapper.
  * @author Name of the author of the wrapper.
  * @package Create a box.json so this can be used as a Forgebox package (yes/no)
  * @wizard Run the init wizard, defaults to false
  */
  function run (
    string apiName = "",
    string apiEndpointUrl = "",
    string apiAuthentication = "apikey",
    string apiDocUrl = '',
    string name = '',
    string description = '',
    string author,
    boolean package = false,
    boolean wizard = false ) {
    
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

    var apiShortName = toShortName( apiName );
    var apiNameSlug = toProperFileName( apiShortName );
    var apiFullName = toFullName( apiName );
    var apiReference = toReferenceSyntax( apiName, apiDocUrl );

    name = name.trim().len() ? name : apiShortName & ' CFML';
    author = author ?: moduleSettings.author;
    //if the endpoint ends with a slash, remove it
    if ( apiEndpointUrl.right( 1 ) == '/' )
      apiEndpointUrl = apiEndpointUrl.left( apiEndpointUrl.len() - 1 );

    print.line();

    for ( var arg in arguments ) {
      if ( !arrayContains( [ 'wizard' ], arg ) )
        print.cyanLine( '- Set #arg# = #arguments[ arg ]#' );
    }
    print.line();

    //let's print some warnings, if the data doesn't look right
    if ( !completeAuthentication().contains( lcase( apiAuthentication ) ) )
        print.yellowLine( "Warning: The apiAuthentication value doesn't match the list of valid options. ApiKey will be used." );
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
      
    //let's create the extra variables that we nsseed
    var substitutions = {
      'name' : name,
      'author' : author,
      'apiEndpointUrl' : apiEndpointUrl,
      'description' : description,
      'nameSlug' : toProperFileName( name ),
      'apiNameSlug' : apiNameSlug,
      'apiNameSlugUcase' : apiNameSlug.uCase(),
      'copyright' : ( author.len() ? '#author#,' : '' ) & ' Matthew J. Clemente, John Berquist',
      'copyrightYear' : now().year(),
      'apiReference' : apiReference
    }

    var projectDirectory = fileSystemUtil.resolvePath( '#substitutions.apiNameSlug#Wrapper' );
    var wrapperDirectory = projectDirectory & '/#substitutions.nameSlug#';

    print.line().boldCyanLine( "Copying template over...." ).toConsole();

    if ( !directoryExists( projectDirectory ) )
      directoryCreate( projectDirectory );
    if ( !directoryExists( wrapperDirectory ) )
      directoryCreate( wrapperDirectory );

    //Prep path for authentication replacements
    if ( apiAuthentication == 'None' ) {
      var authenticationPath = 'authentication/none/';
    } else if ( apiAuthentication == 'Basic' ) {
      var authenticationPath = 'authentication/basic/';    
    } else {
      var authenticationPath = 'authentication/apikey/';
    }

    var serverJson = fileRead( templatePath & "server.json.stub" );
    fileWrite( projectDirectory & "/server.json", serverJson );

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

    var index = fileRead( templatePath & "index.cfm.stub" );
    substitutions.each( 
      function( key, value ) {
        index = index.replaceNoCase( '@@#key#@@', value, 'all' );
      }
    );
    
    //replace credentials in example, based on authentication
    var exampleCredentials = fileRead( templatePath & authenticationPath & 'exampleCredentials' );
    index = index.replaceNocase( '@@exampleCredentials@@', exampleCredentials, 'all' );
    fileWrite( projectDirectory & "/index.cfm", index );

    var template  = fileRead( templatePath & "template.cfc.stub" );

    var authReplacements = [ 'initCredentials', 'secrets', 'authHeaders', 'authCredentials' ];

    authReplacements.each( 
      function( item, index ) {
        var authValue  = fileRead( templatePath & authenticationPath & item );
        template = template.replaceNocase( '@@#item#@@', authValue, 'all' );
      }
    );
    
    substitutions.each( 
      function( key, value ) {
        template = template.replaceNoCase( '@@#key#@@', value, 'all' );
      }
    );

    fileWrite( wrapperDirectory & "/#substitutions.apiNameSlug#.cfc", template );

    if ( package ) {
      print.line().line( "Generating box.json..." );
      var boxDescription = 'A CFML wrapper for #apiFullName#. #description#';
      command( 'cd #wrapperDirectory#' ).run();
      command( 'package init' )
        .params( name=name, slug=substitutions.nameSlug, shortDescription=boxDescription, author=author )
        .run();
      command( 'cd ../../' ).run();
    } else {
      print.line( "Skipping box.json generation." );
    }

    print.line()
      .greenLine( "Success! Your API wrapper is scaffolded!" )
      .line();

    print.line( "Now it's time to CD into the directory and start developing!" );

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
    // replace ampersand with and
    str = str.ReReplace( '&amp;', 'and', 'all' );
    str = str.ReReplace( '&.*?;', '', 'all' );
    str = str.ReReplace( '&', 'and', 'all' );

    // remove any remaining non-word chars
    str = str.ReReplace( '[^a-z0-9]', '', 'all' );

    return str;
  }

  public array function completeAuthentication() {
    return [ 'none', 'basic', 'apikey', 'other' ];
  }

  /**
  * @hint If the name begins with 'the' and ends with 'api', we remove 'the' - it's unneeded. If it ends with 'api', we remove that because it's redundant. Otherwise the name stays the same.
  */
  public string function toShortName( string name ) {
    var shortName = name.trim();
    
    var isDefinite = shortName.left( 4 ) == 'the ';
    var includesAPI = shortName.right( 4 ) == ' api';
    
    if( isDefinite && includesAPI ) {
      print.line( 'Decluttering API name for the slug by removing "the".' );
      //shortName = shortName.mid( 5, shortName.len() - 8 );
      shortName = shortName.right( shortName.len() - 4 );
    } else if( includesAPI ) {
      print.line( 'Decluttering API name for the slug by removing "api".' );
      shortName = shortName.left( shortName.len() - 4 );
    }

    return shortName.trim();
  }

  /**
  * @hint If the name doesn't begin with 'the', we add it. If it doesn't end with 'api', we add that too.
  */
  public string function toFullName( string name ) {
    var fullName = name;

    if( fullName.left( 4 ) != 'the ' ) {
      fullName = 'the ' & fullName;
    }

    if( fullName.right( 3 ) != 'api' ) {
      fullName &= ' API';
    }

    return fullName;
  }

  /**
  * @hint Converts the provided API name and documentation link to a markdown link (with proper placement of the 'the' article, hopefully). If there's no link, the full name of the API is returned.
  */
  public string function toReferenceSyntax( string name, string link ) {
    var apiReference = toFullName( name );

    if( link.len() ) {
      if( name.left( 4 ) == 'the ' ) {
        apiReference = "[#apiReference#](#link#)";
      } else {
        apiReference = "the [#apiReference.replace( 'the ', '' )#](#link#)";
      }
    }

    return apiReference;
  }

}
