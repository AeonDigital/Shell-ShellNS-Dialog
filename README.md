Shell-ShellNS-Dialog
================================

> [Aeon Digital](http://www.aeondigital.com.br)  
> rianna@aeondigital.com.br

&nbsp;

``ShellNS Dialog`` provides functions for standard message interface 
dialog and prompt with the user.  


&nbsp;
&nbsp;

________________________________________________________________________________

## Main

After downloading the repo project, go to its root directory and use one of the 
commands below

``` shell
# Loads the project in the context of the Shell.
# This will download all dependencies if necessary. 
. main.sh "run"



# Installs dependencies (this does not activate them).
. main.sh install

# Update dependencies
. main.sh update

# Removes dependencies
. main.sh uninstall




# Runs unit tests, if they exist.
. main.sh utest

# Runs the unit tests and stops them on the first failure that occurs.
. main.sh utest 1



# Export a new 'package.sh' file for use by the project in standalone mode
. main.sh export
```

&nbsp;
&nbsp;


________________________________________________________________________________

## Standalone

To run the project in standalone mode without having to download the repository 
follow the guidelines below:  

``` shell
# Download with CURL
curl -o "shellns_dialog_standalone.sh" \
"https://raw.githubusercontent.com/AeonDigital/Shell-ShellNS-Dialog/refs/heads/main/standalone/package.sh"

# Give execution permissions
chmod +x "shellns_dialog_standalone.sh"

# Load
. "shellns_dialog_standalone.sh"
```


&nbsp;
&nbsp;


________________________________________________________________________________

## How to use

### Dialog

#### **$1** Type of message

When creating the configuration of a dialog message, the first argument passed 
determines the nature of the dialog.  
The following options can be chosen:


- `info`      : Merely informative message
- `warning`   : Warning message
- `error`     : Unexpected error
- `question`  : Used with prompts that put the user in front of a decision
- `input`     : Use when creating `CLI` form fields
- `ok`        : Success of a user-selected action
- `fail`      : Failure of a user-selected action

&nbsp;

**OBS:**  
The semantic difference between 'error' and 'fail' is subtle. But understand 
the first as a response to a systemic failure and the second as an operator 
failure.  
Making a comparison with the HTTP protocol, 'error' would be 500 errors and 
'fail' 400 errors.

&nbsp;

#### **$2** Message

The second argument passed should be the message you want to show.  
Use 'n' characters to create a multiline message.


&nbsp;

**Examples:**  


``` shell
# Configuration
shellNS_dialog_set "info" "Have a nice day."

# Outputs
shellNS_dialog_show
[  i  ] Have a nice day.


# Multiline messages
# Configuration
strMessage="An unexpected error has occurred.\n"
strMessage+="Check the write permissions in the chosen directory. "
shellNS_dialog_set "error" "${strMessage}"

# Outputs
shellNS_dialog_show
[ err ] An unexpected error has occurred.
        Check the write permissions in the chosen directory. 
```

&nbsp;

### Prompt

Prompt uses a dialog message in conjunction with the 'read' command to get a 
response from the user.

The first and second arguments are the same as those indicated above and the 
others informed below are optional.

#### **$3** Required

If the value is required. Use `1` to define it.
In this case, if the user leaves the prompt blank, it will be shown to him 
again until he enters a value.

&nbsp;

#### **$4** Default

Allows you to enter a default value in case the user leaves the prompt blank.
Filling in this argument causes **$3** to lose its function.

&nbsp;

#### **$5** Trim

Whether the value should pass through a `trim` function. This causes whitespace 
at the beginning and end of the string to be removed.

&nbsp;

#### **$6** Assoc List

If used, it should be the name of an associative array that contains all the 
options that the user can select. In this case, values that are not previously 
defined will not be accepted.

Observe the rules below to learn how to use associative arrays in this function:

``` shell
# The assoc must have Global access
# Keys are the real value that you wants to your user type
# The position of the values should contain any labels that you want to 
# correspond to the respective key.
#
# In the case below the user can type 'y', 'yes', 'ok' or 'confirm' and the 
# prompt will match it to '1'.
# The user can also directly type '1' and it will be accepted.
#
# Values other than those described in the list will be considered invalid and 
# will cause the prompt to appear again to the user.
declare -gA SHELLNS_PROMPT_OPTION_BOOL=(
  ["0"]="n no not cancel"
  ["1"]="y yes ok confirm"
)
```

&nbsp;

#### **$7** Comparison case

Used only if there is a list of values set at **$6**.
By default, the comparison of the values is in case-sensitive ( a != A ).  
Set '0' to disable this behavior. Thus, the comparison will be made in 
case-insensitive ( a == A ).

&nbsp;

#### **$8** Comparison glyphs

Used only if there is a list of values set at **$6**.
By default, the comparison is made taking into account characters with and 
without glyphs (a != ã).
Set '0' to allow a comparison without glyphs (a == ã).


&nbsp;

**Examples:**  


``` shell
# Configuration
strMessage="This will install ShellNS on your computer.\n"
strMessage+="Are you sure you want to continue?"

shellNS_prompt_set "question" "${strMessage}" "0" "1" "1" "SHELLNS_PROMPT_OPTION_BOOL"

# Prompt user
shellNS_prompt_show
[  ?  ] This will install ShellNS on your computer.
        Are you sure you want to continue?
        Select one of the following options:
        [ 0 ] n no not cancel
        [ 1 ] y yes ok confirm
      > yes

# Outputs prompt result
shellNS_prompt_get
1
```


&nbsp;
&nbsp;

________________________________________________________________________________

## Licence

This project uses the [MIT License](LICENCE.md).