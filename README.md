# Description To Command (dtc)

This is a simple shell script that will transform your description of a command
into a command using the OpenAI API with GPT-3 model.

## Pre-requisites

* An [OpenAI API key](https://beta.openai.com/docs/api-reference/authentication),
* [curl](https://curl.se/) to communicate with the OpenAI API,
* [jq](https://stedolan.github.io/jq/) to parse the JSON response from the API.

## Installation

* Copy the `dtc.sh` file to your `~/bin` or any other directory in your `$PATH`.
* Make sure it is executable.
* You can create an alias for the script if you want to use a shorter name.  
  Example for `~/.bashrc`: `alias dtc='~/bin/dtc.sh'`

## Usage

### Without a description

You will get a prompt to enter a description of the command.

```bash
$ ./dtc.sh
Description of the command: make dtc.sh executable
chmod +x dtc.sh
```

### With a description

Everything after the script name will be used as the description.

```bash
$ ./dtc.sh make dtc.sh executable
chmod +x dtc.sh
```

## Example of descriptions

* change the owner of the files to nouser and nogroup recursively and only files, no directories  
  Should be something like `chown -R nouser:nogroup --no-dereference --files-only ./*` or
  `find . -type f -exec chown nouser:nogroup {} \;`.
* create the directory tree test/truc/bidule and change the directory to the last one  
  Should be something like `mkdir -p test/truc/bidule && cd test/truc/bidule`.

