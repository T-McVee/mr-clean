# Mr Clean 
Clean up those messy folders 

## Setup 
1. cd into a dir and git clone repo 
2. Run `chmod +x ./mr-clean.zsh` to make script executable
3.  Run script with`./mr-clean.zsh` followed by:
   - `--help | -h` for a list of commands
   - `--downloads | -dl` to clean up Downloads
   - !!WIP!!  `--desktop | -dk ` to clean up Desktop
   - `--undo | -u` followed by one of the above commands to undo mr-clean's work in the selected directory

## Adding the script to your system $PATH
The following steps are one method of adding mr-clean to your sytem PATH and allowing you to execute the script from any dir without requiring an absolute path to mr-clean.zsh.
1. cd into your root user directory `cd ~`
2. run `mkdir .bin` to create a new .bin dir.
3. copy the `mr-clean.zsh` into this new dir `mv <old-location> ~/.bin`
4. finally, we need to add the absolute path of the mr-clean.zsh to your system path
5. run `cd ~` again to navigate back to your root dir then run `pwd` and take note of the output. This is your absolute path. You will need it in the final step
6. run `ls -a` and locate your `.zshrc` file.
7. open your `.zshrc` file in a text editor and add the following two lines to the file. Anywhere in the file is fine.
  - `export PATH=$PATH:<absolute-path>/.bin/mr-clean` - This adds the script to you system path
  - `alias mr-clean="mr-clean.zsh"` - this allows you to execute the script without requiring the file extension.
8. Restart your terminal and run `mr-clean` to test you've successfully added mr-clean to your system path.
