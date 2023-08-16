apljck
======

There doesn't seem to be a Jupyter kernel for GNU APL (only one for
Dyalog) so this is my plain-text substitute in a few lines of sh.

Turn plain text with GNU APL code in code blocks into plain text with
the code blocks AND the output of the code. Requires only /bin/sh,
/usr/bin/env, Netcat (nc) and of course, GNU APL. 

Blocks are defined with 

    {{{
      [add brillian code here]
    }}}

See test.aplj for a small example that can be processed with

    $ apljck test.aplj

See the variables section at the top of the code. In particular, if
you think you will need more than one second for APL to process a line
of code, increase the value of $T.

