# api-wrapper-template
### A CommandBox tool for scaffolding CFML API Clients
Most modern APIs are built on RESTful(ish) principles. Consequently, while authentication, endpoints, and data will differ, they largely share the same structure for building requests and handling responses. This CommandBox module scaffolds the boilerplate code for making API requests and handling responses, so that you can get down to the business of actually working with the API.

### Acknowledgements

The API wrapper code in this project builds on the API frameworks built by [jcberquist](https://github.com/jcberquist), such as [xero-cfml](https://github.com/jcberquist/xero-cfml) and [aws-cfml](https://github.com/jcberquist/aws-cfml). The structure for building the template is based on [cb-module-template](https://github.com/elpete/cb-module-template), by [elpete](https://github.com/elpete).

## Package Installation

You will need [CommandBox](https://www.ortussolutions.com/products/commandbox) installed to use this tool. ([CFML developer not using CommandBox?](#commandbox-help)) From within the terminal, simply run the following command to install the module.
```
$ box install api-wrapper-template
```

Once the module is installed, it uses the namespace: `apiWrapper`.

## What it does

Running the command `apiWrapper scaffold` creates a folder within the current working directory for building your API wrapper; it includes the boilerplate code needed for handling requests to most APIs. Once you've created a project with the command, you can simply configure authentication and then build out methods for interacting with the API's endpoints. The goal is to streamline the process of writing an API client, so you can focus on the fun part (actually working with the API).

## Using the command: `apiWrapper`

The `apiWrapper` module has two modes:

1. Wizard: For first time users, this is the way to go. Get walked through all of the arguments, with helper text.
2. Manual: Once you've used this module a few times, you may want to manually provide the arguments that you know are applicable to your API.

To scaffold your API wrapper template in Wizard mode, enter the CommandBox CLI and type:
```
apiWrapper scaffold --wizard

#OR

apiWrapper scaffold-wizard
```

<hr>
<a id="commandbox-help"></a><small> If you're a ColdFusion developer and you're not already using CommandBox... you really, really should be. As I've said before, it's hard to explain how helpful it is. If have questions about CommandBox, feel free to ask me, or, for more professional help, ask [Brad Wood](https://twitter.com/bdw429s). </small> [↩](#package-installation) 