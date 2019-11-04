# api-wrapper-template Usage

Once you have used this tool to scaffold a project, you still need to actually write the API wrapper. The following is a brief guide to the conventions and structure of API wrappers built with this project.

## Authenication

Making sure that authentication is handled correctly is the first step in building your API client. Obviously, if there is no authentication, you can skip this section.

### Basic Authentication

tldr; *Handled in the `cfhttp` call, using the `username` and `password` variables*

If you've scaffolded your wrapper with the `basic` option, the assumption is that the API requires a `username` and `password`. In actuality, this is not how most APIs function, so you make need to make some changes. By default, the init method for a wrapper using Basic Authentication is structured like this:

```cfc
public any function init(
  string username = '',
  string password = '',
  string baseUrl = 'https://api.example.com/v1',
  boolean includeRaw = false ) {...}
```

The `username` and `password` are then saved in the variables scope, and used for authentication in the `cfhttp` call in the `apiCall()` method:

```cfc
cfhttp( url = fullPath, method = httpMethod, username = variables.username, password = variables.password, result = 'result' ){...}
```

Depending on how the API that you are working with handled Basic Authentication, you can modify these two portions of the wrapper to more effectively handle it.

### API Key Authentication

tldr; *Set in the `getBaseHttpHeaders()` method, using the `apiKey` variable, which is then provided as a header*

For wrappers scaffolded with the `apikey` option, you'll need to modify the wrapper. This is because API providers implement API Key authentication in a range of ways, so there's no simple way to scaffold a wrapper to handle it. By default, the init method for a wrapper using API Key Authentication is structured like this:

```cfc
public any function init(
  string apiKey = '',
  string baseUrl = 'https://api.example.com/v1',
  boolean includeRaw = false ) {...}
```

### `init()`

### `apiCall()`

### `getBaseHttpHeaders()`

## Method Structure

## Authentication

### Environment Variables
