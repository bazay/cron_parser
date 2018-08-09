# CronParser

Parse simple cron strings from the CLI

## Usage
```
bin/cron_parser --help
```

## Installation
```
bundle install
```

## Requirements

Write a command line application or script which parses a cron string and expands each field to show the times at which it will run. You may use any of the following languages: Ruby, Scala, JavaScript, Python, Go, Java, or C# (using .NET Core as we need it to run on OS X/Linux).

You should only consider the standard cron format with five time fields (minute, hour, day of month, month, and day of week) plus a command; you do not need to handle the special time strings such as "@yearly".

The cron string will be passed to your application on the command line as a single argument on a single line. For example:
```
~$ your-program */15 0 1,15 * 1-5 /usr/bin/find
```
Or:
```
~$ application-commands file-name -arguments */15 0 1,15 * 1-5 /usr/bin/find
```
The output should be formatted as a table with the field name taking the first 14 columns and the times as a space-separated list following it.
For example, the following input argument:
```
*/15 0 1,15 * 1-5 /usr/bin/find
```
should yield the following output:

minute       | 0 15 30 45
---          | ---
hour         | 0
day of month | 1 15
month        | 1 2 3 4 5 6 7 8 9 10 11 12
day of week  | 1 2 3 4 5
command      | /usr/bin/find
  
You should not spend more than three hours on this exercise. If you do not have time to handle all possible cron strings, then an app which handles a subset of them correctly is better than one which does not run or produces incorrect results.

You should see your project reviewer as a new team member you are handing over this project to. Provide everything you feel would be relevant for them to ramp up quickly, such as tests, a README and instructions for how to run your project.
