# Day 1: UNIX and CSC

## Connecting to Puhti

* Launch Visual Studio Code
* _Only on the first time:_ 
    - _Open `Extensions` (one of the icons on the left) and install `Remote - SSH`_  
* Down left corner you will have a (green) button with "><" (hoover over it and it says "Open a Remote Window"), click it 
* Choose "Connect Current Window to Host..."
* Type in the **user<span>@puhti.csc.fi** and hit "Enter" (change "user" for your own CSC username) 
* Type your password and hit "Enter"
* In the following dialogue, type **yes** and hit "Enter"

When the down left corner says `SSH:puhti.csc.fi`, you're connected.
* From the menu select `Terminal > New Terminal` and you should see a new panel. This is the __command line__.

* When you need to logout just type **exit** in the terminal/command line and hit "Enter"  
(or you can click the down left corner and choose "Close Remote Connection")

### Don not want to use VS Code (MacOS [or Linux or WSL] users)

* Launch Terminal
(e.g. open the Launchpad and type **terminal**)
* Type **ssh user<span>@puhti.csc.fi** and hit "Enter" (change "user" for your own CSC username)
* In the following dialogue, type **yes** and hit "Enter"
* Type your password and hit "Enter"
* To logout first type **exit**, hit "Enter", and close the Terminal window

## Playing around with basic UNIX commands

We start with some very basic UNIX exercises to get familiar with the command line.

### Important notes

Things inside a box like this...

```bash
mkdir MMB114
cd MMB114
```
...represent commands you need to type in the shell. Each line is a command. Commands have to be typed in a single line, one at a time. After each command, hit “Enter” to execute it.

Things starting with a pound sign (or hashtag)...

```bash
# This is a comment and is ignored by the shell
```

...represent comments embedded in the code to give instructions to the user. Anything in a line starting with a "#" is ignored by the shell. You can type it if you want, but nothing will happen (provided you start with a "#").

We will be using different commands with different syntaxes. Different commands expect different types of arguments. Some times the order matters, some times it doesn't. If you are unsure, the best way to check how to run a command is by taking a look at its manual with the command **man**. For example, if you want to look at the manual for the command **mkdir** you can do:

```bash
man mkdir

# You can scroll down by hitting the space bar
# To quit, hit "q"
```

### Creating and navigating directories

First let's see where we are:

```bash
pwd
```

Are there any files here? Let's list the contents of the folder:

```bash
ls
```

Let's now create a new folder called "MMB114". In addition to the command (**mkdir**), we are now passing a term (also known as an argument) which, in this case, is the name of the folder we want to create:

```bash
mkdir MMB114
```

Has anything changed? How to list the contents of the folder again?

<details>
<summary>
HINT (CLICK TO EXPAND)
</summary>

> ls

</details>  

---

And now let's enter the "MMB114" folder:

```bash
cd MMB114
```

Did it work? Where are we now?

<details>
<summary>
HINT
</summary>

> pwd

</details>  

### Creating a new file

Let's create a new file called "myfile.txt" by launching the text editor **nano**:

```bash
nano myfile.txt
```

Now inside the nano screen:

1. Write some text

2. Exit with ctrl+x

3. To save the file, type **y** and hit "Enter"

4. Confirm the name of the file and hit "Enter"

List the contents of the folder. Can you see the file we have just created?


### Copying, renaming, moving and deleting files

First let's create a new folder called "myfolder". Do you remember how to do this?

<details>
<summary>
HINT
</summary>

> mkdir myfolder

</details>  

---

And now let's make a copy of "myfile.txt". Here, the command **cp** expects two arguments, and the order of these arguments matter. The first is the name of the file we want to copy, and the second is the name of the new file:

```bash
cp myfile.txt newfile.txt
```

List the contents of the folder. Do you see the new file there?  

Now let's say we want to copy a file and put it inside a folder. In this case, we give the name of the folder as the second argument to **cp**:

```bash
cp myfile.txt myfolder
```

List the contents of "myfolder". Is "myfile.txt" there?

```bash
ls myfolder
```

We can also copy the file to another folder and give it a different name, like this:

```bash
cp myfile.txt myfolder/copy_of_myfile.txt
```

List the contents of "myfolder" again.  Do you see two files there?

Instead of copying, we can move files around with the command **mv**:

```bash
mv newfile.txt myfolder
```

Let's list the contents of the folders. Where did "newfile.txt" go?

We can also use the command **mv** to rename files:

```bash
mv myfile.txt myfile_renamed.txt
```

List the contents of the folder again. What happened to "myfile.txt"?

Now, let's say we want to move things from inside "myfolder" to the current directory. Can you see what the dot (**.**) is doing in the command below? Let's try:

```bash
mv myfolder/newfile.txt .
```

Let's list the contents of the folders. The file "newfile.txt" was inside "myfolder" before, where is it now?  

The same operation can be done in a different fashion. In the commands below, can you see what the two dots (**..**) are doing? Let's try:

```bash
# First we go inside the folder
cd myfolder

# Then we move the file one level up
mv myfile.txt ..

# And then we go back one level
cd ..
```

Let's list the contents of the folders. The file "myfile.txt" was inside "myfolder" before, where is it now?  

We have so many identical files in our folders. Let's clean things up and delete some files :

```bash
rm newfile.txt
```

Let's list the contents of the folder. What happened to "newfile.txt"?  

When deleting files, pay attention in what you are doing: **if you accidently remove the wrong file, it is gone forever!**

And now let's delete "myfolder":

```bash
rm myfolder
```

It didn't work did it? An error message came up, what does it mean?

```bash
rm: cannot remove ‘myfolder’: Is a directory
```

To delete a folder we have to modify the command further by adding the recursive flag (**-r**). Flags are used to pass additional options to the commands:

```bash
rm -r myfolder
```

PS: the following command also works, but only if the folder is empty:

```bash
rmdir myfolder
```

Let's list the contents of the folder. What happened to "myfolder"?  


## Finished and want to learn more?

Try taking some online tutorials, e.g.:

* https://www.learnenough.com/command-line-tutorial
* https://www.codecademy.com/learn/learn-the-command-line
