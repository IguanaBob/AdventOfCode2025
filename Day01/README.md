# Day 1

To start out, lets go back to my roots. The first programming language I did ever was Apple Basic on an Apple IIc. Lets see how good I can do recreating that environment

## PreReqs for Ubuntu 22.04
- MAME (from distro package manager) `sudo apt install mame`
- ROMs for Apple IIc and/or Apple IIe (user-exercise to find these)
- [DOS 3.3 Master .dsk image ](https://mirrors.apple2.org.za/ftp.apple.asimov.net/images/masters/DOS%203.3%20System%20Master%20-%20680-0051-00.dsk)
- [AppleCommander v1.10.1](https://github.com/AppleCommander/AppleCommander/releases/tag/1.10.1) for copying files in-out of .dsk images.

### Create disk to save your work

Run AppleCommander

```
java -jar AppleCommander-linux-x86_64-1.10.1.jar
```

Create a DOS 3.3 disk saved in the same place as your master DOS dsk. I named mine `aoc2025.dsk`

### Run Apple DOS 3.3 in MAME in apple2c mode

```
mame -rompath "$HOME/.mame/roms" apple2ee -window -nomouse -flop1 DOS\ 3.3\ System\ Master\ -\ 680-0051-00.dsk -flop2 aoc2025.dsk -keepaspect -snapsize 560x420
```

![Apple DOS 3.3 Start screen 1](dos1.png) ![Apple DOS 3.3 Start screen 1](dos2.png)

#### Using DOS

List files on OS disk

```
]CATALOG,D1

DISK VOLUME 254

*A 006 HELLO
*I 018 ANIMALS
(many more files)...
```

![CATALOG,D1](cat1.png)

You won't need to worry about most of these, but it's interesting to see.

List files on your data disk.

```
]CATALOG,D2

DISK VOLUME 254

```

![CATALOG,D2](cat2.png)

This should show empty as no files are created yet.

#### Create and run a Hello World program.

```
]NEW
]10 PRINT "HELLO, WORLD!"
]20 END
]LIST
]RUN
]SAVE HELLOWORLD
```

![Hello, World!](hello1.png) ![CATALOG,D2](cat3.png)

### Export files from disk image

If you want to extract files you have saved into the disk image, again run AppleCommander

```
java -jar AppleCommander-linux-x86_64-1.10.1.jar
```

Open aoc2025.dsk, highlight HELLOWORLD. Click export and save the file as an AppleBasic file in your desired path.

## Now for the daily challenge

### Grab the input file

You may want to use the very-short "sample" from the Day 1 explanation first when testing, then once your program is working use your personal very-large input file to get the final answer.

### Convert CRLF and LF to CR

You need to convert endlines to CR for Apple DOS to recognize it as a text file. This is easy enough in linux with `sed` and `tr`.

```
sed 's/\r$//' INPUT.TXT | tr '\n' '\r' > INPUT.TXT.CR
```

Next, load the input file into your data disk with AppleCommander. Be sure to import `INPUT.TXT.CR`, then rename to `INPUT`. If the type is not T (text), then something is wrong.

Once the new dsk is saved, boot back into MAME and list the contents of disk 2.

```
]CATALOG,D2

DISK VOLUME 254

 A 002 HELLOWORLD
 T 002 INPUT

]
```

### Code your program

If you want to go hardcore and program inside of DOS itself, have at it. I'll add explanation for how to do this later.

Alternativly, you can code externally, such as with VSCode, then import into the disk image the same way you did with the INPUT file. Be sure to run it through sed+tr. When importing with AppleCommander be sure the type is "A". I used the file name "DAY1A"

Test running with:

```
RUN DAY1A
```

If it worked, the answer for the sample input should be 3.

### Replace the sample INPUT file with your INPUT file

A working program with the small sample input should only take a few seconds. Once that works, replace INPUT with your input file. This may take a while, so feel free to fast-forward MAME (props to those who try this on real hardware).

To see my final solution code check out DAY1A.bas in this repo.