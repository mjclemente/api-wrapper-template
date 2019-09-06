# api-wrapper-template
### A CommandBox tool for scaffolding CFML API Clients
Most modern APIs are built on RESTful(ish) principles. Consequently, while authentication, endpoints, and data will differ, they largely share the same structure for building requests and handling responses. This CommandBox module scaffolds the boilerplate code for making API requests and handling responses, so that you can get down to the business of actually working with the API.

### Acknowledgements

The API wrapper code in this project builds on the API frameworks built by [jcberquist](https://github.com/jcberquist), such as [xero-cfml](https://github.com/jcberquist/xero-cfml) and [aws-cfml](https://github.com/jcberquist/aws-cfml). The structure for building the template is based on [cb-module-template](https://github.com/elpete/cb-module-template), by [elpete](https://github.com/elpete).

## Package Installation

You will need [CommandBox](https://www.ortussolutions.com/products/commandbox) installed to use this tool. If you're a [CFML developer not using CommandBox](#a-note-on-commandbox-for-new-developers), see my note on the bottom.

From within the terminal, simply run the following command to install the module.
```
$ box install api-wrapper-template
```

Once the module is installed, it uses the namespace: `apiWrapper`.

## What it does

Running the command `apiWrapper scaffold` creates a folder within the current working directory for building your API wrapper; it includes the boilerplate code needed for handling requests to most APIs. Once you've created a project with the command, you can simply configure authentication and then build out methods for interacting with the API's endpoints. The goal is to streamline the process of writing an API client, so you can focus on the fun part (actually working with the API).

## Using the command: `apiWrapper`

The `apiWrapper` module has two modes:

1. Wizard: For first time users, this is the way to go. Get walked through all of the parameters, with helper text.
2. Manual: Once you've used this module a few times, you may want to manually provide the arguments that you know are applicable to your API.

To scaffold your API wrapper template in Wizard mode, enter the CommandBox CLI and type:
```
apiWrapper scaffold --wizard
```

And to run it manualy, simply leave off `--wizard` and provide the desired parameters, for example:
```
apiwrapper scaffold apiName="The Cat API" apiEndpointUrl=http://thecatapi.com/api
```

The module will use the provided parameters to scaffold your API wrapper in the current working directory. So what are the parameters and what do they do? Just continue reading...

### Scaffolding parameters
Here is an overview of the information used to scaffold the API wrapper template; the italicized text is the hint provided by the scaffolding wizard. Asterisks indicate that the parameter is required.

#### `apiName` *
*Name of the API this library will wrap. [i.e. Stripe]* - This is arguably the most important parameter. It's used to generate the name of the project folder and the name of the core CFC file. It's also used as a fallback for generating a name for your wrapper, if you don't provide one yourself. You'll want to keep it short and accurate.

#### `apiEndpointUrl`*
*Base endpoint URL for API calls. [i.e. https://api.stripe.com/v1]* - This value is a constant in nearly all APIs and is generally one of the first things provided in the documentation. It's used as a core variable in the wrapper component; you can't generate the API wrapper if you don't know where the requests are going.

#### `apiAuthentication`
*Type of authentication used [None, Basic, Apikey, Other]* - This value is used to add/remove boilerplate code related to the type of authentication the API requires. The default is `apikey`. If the API uses Basic Authentication or some form of API key authentication, you will likely need to customize the wrapper further, but this will get you started.

#### `apiDocUrl`
*URL of the API documentation homepage* - When this module generates the API wrapper, a README file is created with some basic information about the project. The URL of the API's documentation is included, if you provide it here. This will be helpful for others using your wrapper, and you may actually find it helpful too, as you'll undoubtedly be returning to the docs a lot while writing the wrapper. 

#### `name`
*Name for the wrapper [i.e. StripeCFC]* - This refers to what you want to call your API wrapper project. It doesn't have any practical bearing on how the API wrapper works, but it will appear in the README and in the wrapper component code. If you leave it blank, the wrapper will be named following the convention "{API Name} + CFML".

#### `description`
*A short description of the wrapper.* - Pretty self-explanatory. This text will appear in the README, if you provide it. You can always update it later, as you work on the wrapper.

#### `author`
*Name of the author of the wrapper.* - Your name should go here. It will appear in the copyright text within the wrapper component, as well as the project license.

#### `package`
*Do you want to generate a box.json file, so this wrapper can be used and shared on ForgeBox? [defaults to false]* - If set to true, the arguments used to scaffold the API wrapper will also be used to populate a box.json file, so that you can distribute this package on ForgeBox Not sure what that means? I wrote a blog post about [publishing my first package to ForgeBox](https://blog.mattclemente.com/2018/02/20/publishing-my-first-package-to-forgebox.html); you can also check out the [official CommandBox docs on packages](https://commandbox.ortusbooks.com/package-management/creating-packages).


___
### A Note on CommandBox for New Developers
If you're a ColdFusion developer and you're not already using CommandBox... you really, really should be. As I've said before, it's hard to explain how helpful it is. If have questions about CommandBox, feel free to ask me, or, for more professional help, ask [Brad Wood](https://twitter.com/bdw429s). [↩](#package-installation) 