apljack
=======

There doesn't seem to be a Jupyter kernel for GNU APL (only one for
Dyalog) so this is my plain-text substitute in a few lines of sh.

Turn plain text with GNU APL code in code blocks into plain text with
the code blocks AND the output of the code. Requires only /bin/sh,
/usr/bin/env, mktemp, mkfifo, and of course, GNU APL. 

The main point is that APL state is conserved between code blocks.

Blocks are defined with triplets of opening and closing curly brackets:

     {{{
     [add brilliant code here]
     }}}

See test.aj for a small example that can be processed with

    $ aj test.aj

You don't have to use the .aj extension. I just did for the heck of it.

Also, because of the nature of the hack (and yes, it's a terrible hack)
you can't do this:

    $ aj text.aj > output.txt

It will get confused and die. So, unfortunately, you have to just use
a terminal emulator with which you can cut and paste the output. I do
not like this. No, Sam-I-Am, I do not like this one bit. But it's
better than nothing. At some point I may try to fix it, when I
understand Unix pipes and redirection and file descriptors, and all
the rest better.

See the variables section at the top of the code. In particular, if
you think you will need more than one second for APL to process a line
of code, increase the value of $t.

Finally note that BSD doesn't have the same /proc system setup that Linux does, so this doesn't work there, but a better way to do this should be found anyway. It would be nice if GNU APL had something like Haskell's "bird style" comments. Then none of this would be necessary.


