# Day 01: Linux and CSC

## Connecting to CSC

### Windows users

* Launch PuTTY
* In “Host Name (or IP address)”, type **taito.csc.fi** and click “Open”
* In the following dialogue window, choose “Yes”
* Type your CSC username
* Type your password
* To quit PuTTY just type **exit**

### MacOS users

* Launch Terminal
(e.g. open the Launchpad and type **terminal**)
* Type **ssh user<span>@taito.csc.fi** (change "user" for your own CSC username)
* In the following dialogue, type **yes**
* Type your password
* To quit Terminal first type **exit** and then close the window

## Playing around with basic UNIX commands

### Important notes

Things inside a box like this...

```bash
mkdir MMB-114
```
...represent commands you need to type in the shell.

---

When you see something like this...

```bash
cd /wrk/<yourusername>
```

...it means you'll need to change the text, in this example, with you own username **(but without the < > !!!)**, like this:

```bash
cd /wrk/stelmach
```

---

Commands have to be written in one line.  
To execute the command, simply hit "Enter".
