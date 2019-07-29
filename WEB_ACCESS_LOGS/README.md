## Access Log Messages

It's possible to generate access log messages for web access (see [pull request 12264](https://github.com/wildfly/wildfly/pull/12264)).

The log format can be customized (see [io.undertow.server.handlers.accesslog.AccessLogHandler](http://undertow.io/javadoc/1.3.x/io/undertow/server/handlers/accesslog/AccessLogHandler.html)):

```html

available patterns

%a - Remote IP address
%A - Local IP address
%b - Bytes sent, excluding HTTP headers, or '-' if no bytes were sent
%B - Bytes sent, excluding HTTP headers
%h - Remote host name
%H - Request protocol
%l - Remote logical username from identd (always returns '-')
%m - Request method
%p - Local port
%q - Query string (excluding the '?' character)
%r - First line of the request
%s - HTTP status code of the response
%t - Date and time, in Common Log Format format
%u - Remote user that was authenticated
%U - Requested URL path
%v - Local server name
%D - Time taken to process the request, in millis
%T - Time taken to process the request, in seconds
%I - current Request thread name (can compare later with stacktraces)

aliases for commonly utilized patterns:

common - %h %l %u %t "%r" %s %b
combined - %h %l %u %t "%r" %s %b "%{i,Referer}" "%{i,User-Agent}"

support to write information from the cookie, incoming header, or the session:

%{i,xxx} for incoming headers
%{o,xxx} for outgoing response headers
%{c,xxx} for a specific cookie
%{r,xxx} xxx is an attribute in the ServletRequest
%{s,xxx} xxx is an attribute in the HttpSession

```

The logs get generated as soon as some request is processed;

For specific configuration, see:

* [solutions#2423311](https://access.redhat.com/solutions/2423311)
* [solutions#2172691](https://access.redhat.com/solutions/2172691)