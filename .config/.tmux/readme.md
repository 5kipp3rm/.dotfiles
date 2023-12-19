Tmux Configuration
=====================
Tmux configuration, that supercharges your [tmux](https://tmux.github.io/) and builds cozy and cool terminal environment.

![intro](https://user-images.githubusercontent.com/768858/33152741-ec5f1270-cfe6-11e7-9570-6d17330a83aa.gif)

Table of contents
-----------------

- [Tmux Configuration](#tmux-configuration)
  - [Table of contents](#table-of-contents)
  - [Features](#features)
  - [Installation](#installation)
  - [General settings](#general-settings)
  - [Key bindings](#key-bindings)
  - [Status line](#status-line)
  - [Nested tmux sessions](#nested-tmux-sessions)
    - [Local and remote sessions](#local-and-remote-sessions)
  - [Copy mode](#copy-mode)
  - [Clipboard integration](#clipboard-integration)
  - [Themes and customization](#themes-and-customization)
  - [iTerm2 and tmux integration](#iterm2-and-tmux-integration)
- [Awesome Tmux](#awesome-tmux)
  - [Table of Contents](#table-of-contents-1)
  - [Tutorials](#tutorials)
  - [Cheat Sheets](#cheat-sheets)
  - [Configuration](#configuration)
  - [Tools and session management](#tools-and-session-management)
  - [Themes](#themes)
  - [Status Bar](#status-bar)
  - [Plugins](#plugins)
    - [Development and testing](#development-and-testing)
  - [Books](#books)
  - [Miscellaneous](#miscellaneous)

Features
---------

- "C-a" prefix instead of "C-b" (screen like)
- support for nested tmux sessions
- local vs remote specific session configuration
- scroll and copy mode improvements
- integration with OSX or Linux clipboard (works for local, remote, and local+remote nested session scenario)
- supercharged status line
- renew tmux and shell environment (SSH_AUTH_SOCK, DISPLAY, SSH_TTY) when reattaching back to old session
- prompt to rename window right after it's created
- newly created windows and panes retain current working directory
- monitor windows for activity/silence
- highlight focused pane
- merge current session with existing one (move all windows)
- configurable visual theme/colors, with some elements borrowed from [Powerline](https://github.com/powerline/powerline)
- integration with 3rd party plugins: [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar), [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat), [tmux-open](https://github.com/tmux-plugins/tmux-open), [tmux-plugin-sysstat](https://github.com/samoshkin/tmux-plugin-sysstat)

**Status line widgets**:

- CPU, memory usage, system load average metrics
- username and hostname, current date time
- battery information in status line
- visual indicator when you press `prefix`
- visual indicator when you're in `Copy` mode
- visual indicator when pane is zoomed
- online/offline visual indicator
- toggle visibility of status line


Installation
-------------
Prerequisites:
- tmux >= "v2.4"
- OSX, Linux (tested on Ubuntu 14 and CentOS7), FreeBSD (tested on 11.1)

Personally, I use it on OSX 10.11.5 El Capitan through iTerm2.

On OSX you can install latest 2.6 version with `brew install tmux`. On Linux it's better to install from source, because official repositories usually contain outdated version. For example, CentOS7 - v1.8 from base repo, Ubuntu 14 - v1.8 from trusty/main. For how to install from source, see this [gist](https://gist.github.com/P7h/91e14096374075f5316e) or just google it.


To install tmux-config:
```
$ git clone https://github.com/samoshkin/tmux-config.git
$ ./tmux-config/install.sh
```

`install.sh` script does following:
- copies files to `~/.tmux` directory
- symlink tmux config file at `~/.tmux.conf`, existing `~/.tmux.conf` will be backed up
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) will be installed at default location `~/.tmux/plugins/tpm`, unless already presemt
- required tmux plugins will be installed

Finally, you can jump into a new tmux session:

```
$ tmux new
```


General settings
----------------
Windows and pane indexing starts from `1` rather than `0`. Scrollback history limit is set to `20000`. Automatic window renameing is turned off. Aggresive resizing is on. Message line display timeout is `1.5s`. Mouse support in `on`.

256 color palette support is turned on, make sure that your parent terminal is configured propertly. See [here](https://unix.stackexchange.com/questions/1045/getting-256-colors-to-work-in-tmux) and [there](https://github.com/tmux/tmux/wiki/FAQ)

```
# parent terminal
$ echo $TERM
xterm-256color

# jump into a tmux session
$ tmux new
$ echo $TERM
screen-256color
```

Key bindings
-----------
So `~/.tmux.conf` overrides default key bindings for many action, to make them more reasonable, easy to recall and comforable to type.

Let's go through them. 

If you are an iTerm2 user, third column describes the keybinding of similar  "action" in iTerm2. It's possible to reuse very same keys you already get used to and tell iTerm2 to execute analogous tmux actions. See [iTerm2 and tmux integration](#iterm2-and-tmux-integration) section below.

<table>
    <tr>
        <td nowrap><b>tmux key</b></td>
        <td><b>Description</b></td>
        <td><b>iTerm2 key</b></td>
    </tr>
    <tr>
        <td nowrap><code>C-a</code></td>
        <td>Default prefix, used instead of "C-b". Same prefix is used in screen program, and it's easy to type. The only drawback of "C-a" is that underlying shell does not receive the keystroke to move to the beginning of the line.
        </td>
        <td>-</td>
    </tr>
    <tr>
        <td nowrap><code>&lt;prefix&gt; C-e</code></td>
        <td>Open ~/.tmux.conf file in your $EDITOR</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-r</code></td>
        <td>Reload tmux configuration from ~/.tmux.conf file</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; r</code></td>
        <td>Rename current window</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; R</code></td>
        <td>Rename current session</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; _</code></td>
        <td>Split new pane horizontally</td>
        <td>⌘⇧D</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; |</code></td>
        <td>Split new pane vertically</td>
        <td>⌘D</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; &lt;</code></td>
        <td>Select next pane</td>
        <td>⌘[</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; &gt;</code></td>
        <td>Select previous pane</td>
        <td>⌘]</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; ←</code></td>
        <td>Select pane on the left</td>
        <td>⌘⌥←</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; →</code></td>
        <td>Select pane on the right</td>
        <td>⌘⌥→</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; ↑</code></td>
        <td>Select pane on the top</td>
        <td>⌘⌥↑</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; ↓</code></td>
        <td>Select pane on the bottom</td>
        <td>⌘⌥↓</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-←</code></td>
        <td>Resize pane to the left</td>
        <td>^⌘←</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-→</code></td>
        <td>Resize pane to the right</td>
        <td>^⌘→</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-↑</code></td>
        <td>Resize pane to the top</td>
        <td>^⌘↑</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-↓</code></td>
        <td>Resize pane to the bottom</td>
        <td>^⌘↓</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; &gt;</code></td>
        <td>Move to next window</td>
        <td>⌘⇧]</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; &lt;</code></td>
        <td>Move to previous window</td>
        <td>⌘⇧[</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; Tab</code></td>
        <td>Switch to most recently used window</td>
        <td>^Tab</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; L</code></td>
        <td>Link window from another session by entering target session and window reference</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; \</code></td>
        <td>Swap panes back and forth with 1st pane. When in main-horizontal or main-vertical layout, the main panel is always at index 1. This keybinding let you swap secondary pane with main one, and do the opposite.</td>
        <td>⌘\</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-o</code></td>
        <td>Swap current active pane with next one</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; +</code></td>
        <td>Toggle zoom for current pane</td>
        <td>⌘⇧Enter</td>
    </td>
    <tr>
        <td><code>&lt;prefix&gt; x</code></td>
        <td>Kill current pane</td>
        <td>⌘W</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; X</code></td>
        <td>Kill current window</td>
        <td>⌘⌥W</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-x</code></td>
        <td>Kill other windows but current one (with confirmation)</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; Q</code></td>
        <td>Kill current session (with confirmation)</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-u</code></td>
        <td>Merge current session with another. Essentially, this moves all windows from current session to another one</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; d</code></td>
        <td>Detach from session</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; D</code></td>
        <td>Detach other clients except current one from session</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; C-s</code></td>
        <td>Toggle status bar visibility</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; m</code></td>
        <td>Monitor current window for activity</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; M</code></td>
        <td>Monitor current window for silence by entering silence period</td>
        <td>-</td>
    </tr>
    <tr>
        <td><code>&lt;prefix&gt; F12</code></td>
        <td>Switch off all key binding and prefix hanling in current window. See "Nested sessions" paragraph for more info</td>
        <td>-</td>
    </tr>
</table>


Status line
-----------

I've started with Powerline as a status line, but then realized it's too fat for my Macbook 15'' display, it hardly can fit all those fancy arrows, widgets and separators, so that I can only see one window "tab".

So I decide to make my feet wet, with the idea to keep it dense, and include essential widgets. Sometimes it tries to replicate OSX topbar (battery, date time).

Left part:
![status line left](https://user-images.githubusercontent.com/768858/33151594-59db6a8e-cfe1-11e7-8a36-476fe0b416b3.png)

Right part:
![status line right](https://user-images.githubusercontent.com/768858/33151608-6978de72-cfe1-11e7-829a-e303e31e8c16.png)

The left part contains only current session name.

Window tabs use Powerline arrows glyphs, so you need to install Powerline enabled font to make this work. See [Powerline docs](https://powerline.readthedocs.io/en/latest/installation.html#fonts-installation) for instructions and here is the [collection of patched fonts for powerline users](https://github.com/powerline/fonts)

The right part of status line consists of following components:

- CPU, memory usage, system load average metrics. Powered by [tmux-plugin-sysstat](https://github.com/samoshkin/tmux-plugin-sysstat) (dislaimed, that's my own development, because I haven't managed to find any good plugin with CPU and memory/swap metrics)
- username and hostname (invaluable when you SSH onto remote host)
- current date time
- battery information
- visual indicator when you press prefix key: `[^A]`.
- visual indicator when pane is zoomed: `[Z]`
- online/offline visual indicator (just pings `google.com`)

You might want to hide status bar using `<prefix> C-s` keybinding.


Nested tmux sessions
--------------------
One prefers using tmux on local machine to supercharge their terminal emulator experience, other use it only for remote scenarios to retain session/state in case of disconnect. Things are getting more complex, when you want to be on both sides. You end up with nested session, and face the question: **How you can control inner session, since all keybindings are caught and handled by outer session?**. Community provides several possible solutions.

The most common is to press `C-a` prefix twice. First one is caught by local session, whereas second is passed to remote one. Nothing extra steps need to be done, this works out of the box. However, root keytable bindings are still handled by outer session, and cannot be passed to inner one.

Second attempt to tackle this issue, is to [setup 2 individual prefixes](https://simplyian.com/2014/03/29/using-tmux-remotely-within-a-local-tmux-session/), `C-b` for local session, and `C-a` for remote session. And, you know, it feels like:

![tmux in tmux](http://i.imgur.com/HQBdV1J.jpg)

And finally accepted solution, turn off all keybindings and key prefix handling in outer session, when working with inner one. This way, outer session just sits aside, without interfering keystrokes passed to inner session. Credits to [http://stahlke.org/dan/tmux-nested/](http://stahlke.org/dan/tmux-nested/) and this [Github issue](https://github.com/tmux/tmux/issues/237)

So, how it works. When in outer session, simply press `F12` to toggle off all keybindings handling in outer session. Now work with inner session using the same keybinding scheme and same keyprefix. Press `F12` to turn on outer session back.

![nested sessions](https://user-images.githubusercontent.com/768858/33151636-84a0bab2-cfe1-11e7-9d5d-412525689c9b.gif)

You might notice that when key bindings are "OFF", special `[OFF]` visual indicator is shown in the status line, and status line changes its style (colored to gray).

###  Local and remote sessions

Remote session is detected by existence of `$SSH_CLIENT` variable. When session is remote, following changes are applied:
- status line is docked to bottom; so it does not stack with status line of local session
- some widgets are removed from status line: battery, date time. The idea is to economy width, so on wider screens you can open two remote tmux sessions in side-by-side panes of single window of local session.

You can apply remote-specific settings by extending `~/.tmux/.tmux.remote.conf` file.


Copy mode
----------------------
There are some tweaks to copy mode and scrolling behavior, you should be aware of.

There is a root keybinding to enter Copy mode: `M-Up`. Once in copy mode, you have several scroll controls:

- scroll by line: `M-Up`, `M-down`
- scroll by half screen: `M-PageUp`, `M-PageDown`
- scroll by whole screen: `PageUp`, `PageDown`
- scroll by mouse wheel, scroll step is changed from `5` lines to `2`

`Space` starts selection, `Enter` copies selection and exits copy mode. List all items in copy buffer using `prefix C-p`, and paste most recent item from buffer using `prexix p`.

`y` just copies selected text and is equivalent to `Enter`,  `Y` copies whole line, and `D` copies by the end of line.

Also, note, that when text is copied any trailing new lines are stripped. So, when you paste buffer in a command prompt, it will not be immediately executed.

You can also select text using mouse. Default behavior is to copy text and immediately cancel copy mode on `MouseDragEnd` event. This is annoying, because sometimes I select text just to highlight it, but tmux drops me out of copy mode and reset scroll by the end. I've changed this behavior, so `MouseDragEnd` does not execute `copy-selection-and-cancel` action. Text is copied, but copy mode is not cancelled and selection is not cleared. You can then reset selection by mouse click.

![copy and scroll](https://user-images.githubusercontent.com/768858/33231146-e390afc8-d1f8-11e7-80ad-6977fc3a5df7.gif)

Clipboard integration
----------------------

When you copy text inside tmux, it's stored in private tmux buffer, and not shared with system clipboard. Same is true when you SSH onto remote machine, and attach to tmux session there. Copied text will be stored in remote's session buffer, and not shared/transported to your local system clipboard. And sure, if you start local tmux session, then jump into nested remote session, copied text will not land in your system clipboard either.

This is one of the major limitations of tmux, that you might just decide to give up using it. Let's explore possible solutions:

- share text with OSX clipboard using **"pbcopy"**
- share text with OSX clipboard using [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard) wrapper to access "pbcopy" from tmux environment (seems on OSX 10.11.5 ElCapitan this is not needed, since I can still access pbcopy without this wrapper).
- share text with X selection using **"xclip"** or **"xsel"** (store text in primary and clipboard selections). Works on Linux when DISPLAY variable is set.

All solutions above are suitable for sharing tmux buffer with system clipboard for local machine scenario. They still does not address remote session scenarios. What we need is some way to transport buffer from remote machine to the clipboard on the local machine, bypassing remote system clipboard.

There are 2 workarounds to address remote scenarios.

Use **[ANSI OSC 52](https://en.wikipedia.org/wiki/ANSI_escape_code#Escape_sequences)** escape [sequence](https://blog.vucica.net/2017/07/what-are-osc-terminal-control-sequences-escape-codes.html) to talk to controlling/parent terminal and pass buffer on local machine. Terminal should properly undestand and handle OSC 52. Currently, only iTerm2 and XTerm support it. OSX Terminal, Gnome Terminal, Terminator do not.

Second workaround is really involved and consists of [local network listener and SSH remote tunneling](https://apple.stackexchange.com/a/258168):

- SSH onto target machine with remote tunneling on
    ```
    ssh -R 2222:localhost:3333  alexeys@192.168.33.100
    ```
- When text is copied inside tmux (by mouse, by keyboard by whatever configured shortcut), pipe text to network socket on remote machine
    ```
    echo "buffer" | nc localhost 2222
    ```
- Buffer will be sent thru SSH remote tunnel from port `2222` on remote machine to port `3333` on local machine.
- Setup a service on local machine (systemd service unit with socket activation), which listens on network socket on port `3333`, and pipes any input to `pbcopy` command (or `xsel`, `xclip`).

This tmux-config does its best to integrate with system clipboard, trying all solutions above in order, and falling back to OSC 52 ANSI escape sequences in case of failure. 

On OSX you might need to install `reattach-to-user-namespace` wrapper: `brew install reattach-to-user-namespace`, and make sure OSC 52 sequence handling is turned on in iTerm. (Preferences -> General -> Applications in Terminal may access clipboard).

On Linux, make sure `xclip` or `xsel` is installed. For remote scenarios, you would still need to setup network listener and use SSH remote tunneling, unless you terminal emulators supports OSC 52 sequences.





Themes and customization
------------------------

All colors related to theme are declared as variables. You can change them in `~/.tmux.conf`.

```
# This is a theme CONTRACT, you are required to define variables below
# Change values, but not remove/rename variables itself
color_dark="$color_black"
color_light="$color_white"
color_session_text="$color_blue"
color_status_text="colour245"
color_main="$color_orange"
color_secondary="$color_purple"
color_level_ok="$color_green"
color_level_warn="$color_yellow"
color_level_stress="$color_red"
color_window_off_indicator="colour088"
color_window_off_status_bg="colour238"
color_window_off_status_current_bg="colour254"
```

Note, that variables are not extracted to dedicated file, as it should be, because for some reasons, tmux does not see variable values after sourcing `theme.conf` file. Don't know why.


iTerm2 and tmux integration
---------------------------

If you're an iTerm use same to me, most likely you already have a muscle memory for most common actions and keybindings (split pane, focus pane, fullscreen pane, move between tabs, create new tab, etc). When I switched to tmux, I found new key table more difficult: more keys to type, don't forget to enter `prefix` and recall if you've already pressed it or not (compare `C-a, c` with "⌘T", or `C-a ->` with "⌘⌥->"). iTerm2 keybinding was so natural to me, so I decided to remap most common keybindings to tell iTerm2 to execute corresponding tmux actions.

You can setup new profile in iTerm preferences to override default keybindings, to tell iTerm to send pre-configured sequences of keys, that will trigger corresponding action in tmux.

![iterm preferences](https://user-images.githubusercontent.com/768858/33185301-54afc402-d08a-11e7-9622-232a4607df8b.png)

For example, when "^⌘↑" pressed, sequence of bytes `0x01 0x1b 0x5b 0x31 0x3b 0x35 0x41` are sent through terminal to running tmux instance, that interprets them as `C-a C-↑` keybinding and triggers `resize-pane -U` according to our `.tmux.conf` configuration.

You can get binary representation of any keys, using `showkey` or `od` commands

```
$od -t x1

^A^[[1;5A   // press C-a C-↑ on your keyboard
0000000 01 1b 5b 31 3b 35 41
0000007
```

```
$ showkey -a
Press any keys - Ctrl-D will terminate this program

^A        1 0001 0x01
^[[1;5A  27 0033 0x1b
         91 0133 0x5b
         49 0061 0x31
         59 0073 0x3b
         53 0065 0x35
         65 0101 0x41
```

You can remap whatever key in this way, but I do this only for those ones, which have similar analogous action in tmux and are most common(resize pane, zoom pane, create new window, etc). See table with keybindings above.

As additional step, you can setup this new iTerm profile as default one, and tell it to jump into tmux session right off the start.

![iterm tmux default profile](https://user-images.githubusercontent.com/768858/33185302-54d36b78-d08a-11e7-96b9-7ab3069fc369.png)

You can then go full screen in iTerm, so iTerm tabs and frame do not distract you (anyway now you're using iTerm just as a tunnel to your tmux, everything else happens inside tmux).

![full screen mode](https://user-images.githubusercontent.com/768858/33185303-54fa0378-d08a-11e7-8fd3-068f0af712c7.png)


Awesome [Tmux](https://tmux.github.io/)
====

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

List of helpful tmux links for various tutorials, plugins, and configuration settings.

## Table of Contents

- [Tutorials](#tutorials)
- [Cheat sheets](#cheatsheets)
- [Configuration](#configuration)
- [Tools and session management](#tools)
- [Themes](#themes)
- [Status Bar](#status-bar)
- [Plugins](#plugins)
- [Books](#books)
- [Miscellaneous](#miscellaneous)

## Tutorials

- [Automatically start tmux on SSH](http://marklodato.github.io/2013/10/31/autostart-tmux-on-ssh.html)
- [Tmux crash course](https://thoughtbot.com/blog/a-tmux-crash-course)
- [Tmux primer](https://danielmiessler.com/study/tmux/)
- [Tmux and Vim together](https://www.bugsnag.com/blog/tmux-and-vim)

## <a name="cheatsheets"></a>Cheat Sheets

- [tmux-cheatsheet.markdown](https://gist.github.com/MohamedAlaa/2961058)

## Configuration

- [Oh My Tmux!](https://github.com/gpakosz/.tmux) Powerline-like theme, vim bindings, SSH aware, improved maximize pane, ...
- [Example tmux config](https://github.com/tony/tmux-config) :green_book: Example tmux configuration - screen + vim key-bindings, system stat, cpu load bar
- [Guide to customizing tmux.conf](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/)
- [practical tmux](https://mutelight.org/practical-tmux)
- [tmux-extra](https://github.com/brandur/tmux-extra) Configuration and scripts for sane Tmux default behavior
- [tmux yank to system clipboard](https://www.grailbox.com/2020/08/use-system-clipboard-for-vi-copy-mode-in-tmux-in-macos-and-linux/) A way to get the System Clipboard to work with tmux yank on a Mac via `pbcopy` and linux via `xclip`

## <a name="tools"></a>Tools and session management

- [automux](https://github.com/sriramkandukuri/automux) Wrappers to tmux commands, useful for tmux based automation
- [disconnected](https://github.com/austinwilcox/disconnected) A session manager written in Deno with json as the config files
- [dmux](https://github.com/zdcthomas/dmux) Configurable tmux workspace manager written in Rust
- [libtmux](https://github.com/tmux-python/libtmux) Python API for tmux
- [powerline](https://github.com/powerline/powerline) Statusline plugin for vim, and provides statuslines and prompts for several other applications including tmux
- [tmux-powerline](https://github.com/erikw/tmux-powerline) A hackable statusbar for tmux consisting of dynamic & beautiful looking segments, inspired by vim-powerline, written purely in bash.
- [smug](https://github.com/ivaaaan/smug) A session manager for tmux written in Go
- [t](https://github.com/joshmedeski/t-smart-tmux-session-manager) The smart tmux session manager
- [tat](https://github.com/ryandotsmith/tat) Tab completion for tmux sessions
- [teamocil](https://github.com/remi/teamocil) A simple tool used to automatically create windows and panes in tmux with YAML files
- [tmex](https://github.com/evnp/tmex) A minimalist tmux layout manager
- [tmux-cssh](https://github.com/zinic/tmux-cssh) Tmux with a "ClusterSSH"-like behavior
- [tmux-conf](https://github.com/jaclu/tmux-conf) Meant for users running tmux on multiple hosts, not always running the same version. Generates tmux config files using version checks
- [tmux-nav-master](https://github.com/TheSast/tmux-nav-master) Easy cross-navigation between tmux and other terminal applications.
- [tmux-project](https://github.com/sei40kr/tmux-project) Search projects and open them in a new session
- [tmux-suspend](https://github.com/MunifTanjim/tmux-suspend) Suspend local session for painlessly working with nested remote session.
- [tmux-up](https://github.com/jamesottaway/tmux-up) Bootstrap new `tmux` sessions without complex tools, DSLs, or dependencies
- [tmuxake](https://github.com/nkh/tmuxake) A side-pane manager for tmux
- [tmuxifier](https://github.com/jimeh/tmuxifier) Tmuxify your Tmux. Powerful session, window & pane management for Tmux.
- [tmuxinator](https://github.com/tmuxinator/tmuxinator) Manage complex tmux sessions easily
- [tmuxp](https://github.com/tmux-python/tmuxp) :computer: tmux session manager and python library
- [tmuxpair](https://github.com/goerz/tmuxpair) Command line script for setting up a temporary tmux session for pair programming
- [twm](https://github.com/vinnymeller/twm) A highly configurable workspace manager that is easy to extend with shell scripts, written in Rust
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) Vim and tmux integration
- [xpanes](https://github.com/greymd/tmux-xpanes) Awesome tmux-based terminal divider

## Themes

- [catppuccin](https://github.com/catppuccin/tmux) Catppuccin `Latte`, `Frappe`, `Macchiato`, and `Mocha` themes for tmux.
- [dracula/tmux](https://github.com/dracula/tmux) 🧛🏻‍♂️ The official [dracula theme](https://draculatheme.com/) for tmux
- [minimal-tmux-status](https://github.com/niksingh710/minimal-tmux-status/): Minimal theme with only required information in status bar and prefix indicator. (changes only status bar)
- [nord tmux](https://github.com/arcticicestudio/nord-tmux) An arctic, north-bluish clean and elegant tmux color theme.
- [tmux-base16-statusline](https://github.com/jatap/tmux-base16-statusline) Statusline based on [base16-shell](https://github.com/chriskempson/base16-shell)
- [tmux-colors-solarized](https://github.com/seebi/tmux-colors-solarized) A color theme for the tmux terminal multiplexer using Ethan Schoonover’s Solarized color scheme
- [tmux-dark-notify](https://github.com/erikw/tmux-dark-notify) - Make tmux's theme follow macOS dark/light mode.
- [tmux-gruvbox](https://github.com/egel/tmux-gruvbox) Light and dark tmux theme
- [tmux-nova](https://github.com/o0th/tmux-nova) Fully customizable tmux theme
- [tmux-power](https://github.com/wfxr/tmux-power) 8 powerline style themes for tmux, easily to expand.
- [tmux-snazzy](https://github.com/ivnvxd/tmux-snazzy) Elegant tmux theme with bright colors
- [tmux-themepack](https://github.com/jimeh/tmux-themepack) Various themes for tmux
- [tmux-tokyo-night](https://github.com/fabioluciano/tmux-tokyo-night) A vim inspired tokyo night theme
- [tokyo-night-tmux](https://github.com/janoamaral/tokyo-night-tmux) tokyo-night theme for tmux
- [tomorrow](https://github.com/edouard-lopez/tmux-tomorrow/): 5 flavors of Tomorrow theme based on specifications from [Tomorrow Theme](https://github.com/chriskempson/tomorrow-theme) (_i.e._ _dark_/_blue_ and _light_).

## Status Bar

- [aws-tmux](https://github.com/darko-mesaros/aws-tmux) Tmux plugin that gives you access to some (potentially) useful information about AWS.
- [gitmux](https://github.com/arl/gitmux) Show Git status in tmux status bar
- [tmux-battery](https://github.com/tmux-plugins/tmux-battery) Plug and play battery percentage and icon indicator for Tmux.
- [tmux-clima](https://github.com/vascomfnunes/tmux-clima) Displays the current temperature and weather condition using the OpenWeather API.
- [tmux-colortag](https://github.com/Determinant/tmux-colortag) a plugin/theme that colors the tmux window tags.
- [tmux-cpu-info](https://github.com/jdxcode/tmux-cpu-info) CPU usage gauge to status bar
- [tmux-cpu](https://github.com/tmux-plugins/tmux-cpu) Show CPU load with easy icons
- [tmux-df](https://github.com/tassaron/tmux-df) - Show available disk space (output of df command)
- [tmux-kripto](https://github.com/vascomfnunes/tmux-kripto) Add a cryptocurrency stock price to the statusbar.
- [tmux-maildir-counter](https://github.com/tmux-plugins/tmux-maildir-counter) Plugin that counts files on a specific mail directory
- [tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load) CPU, RAM memory, and load monitor for use with tmux
- [tmux-mode-indicator](https://github.com/MunifTanjim/tmux-mode-indicator) Displays prompt indicating currently active Tmux mode.
- [tmux-mpv-info](https://github.com/Feqzz/tmux-mpv-info) Displays the current song playing with MPV in your tmux status bar.
- [tmux-mullvad](https://github.com/jaclu/tmux-mullvad) - Keep track of [Mullvad VPN](https://mullvad.net/) status.
- [tmux-ludanta](https://github.com/vascomfnunes/tmux-ludanta) - What's playing
  on an MPD local server.
- [tmux-nerd-font-window-name](https://github.com/joshmedeski/tmux-nerd-font-window-name) Nerd Font icons for your tmux windows
- [tmux-network-bandwidth](https://github.com/xamut/tmux-network-bandwidth) Show
  network bandwidth
- [tmux-nordvpn](https://github.com/maxrodrigo/tmux-nordvpn) Monitor the current NordVPN connection status.
- [tmux-online-status](https://github.com/tmux-plugins/tmux-online-status) Tmux plugin that displays online status of your computer
- [tmux-packet-loss](https://github.com/jaclu/tmux-packet-loss) - Displays packet loss % if at or above the specified threshold level
- [tmux-piavpn](https://github.com/Brutuski/tmux-piavpn) Keep track of your [Private Internet Access](https://www.privateinternetaccess.com/) VPN status.
- [tmux-plugin-playerctl](https://github.com/richin13/tmux-plugin-playerctl) Display [MPRIS](https://www.freedesktop.org/wiki/Specifications/mpris-spec/) metadata in Tmux (Spotify, Clementine, VLC, etc)
- [tmux-pomodoro-plus](https://github.com/olimorris/tmux-pomodoro-plus) Incorporate the Pomodoro technique into your tmux workflow
- [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight) Plugin that highlights when you press tmux prefix key
- [tmux-split-statusbar](https://github.com/charlietag/tmux-split-statusbar) Plugin for splitting status bar into 2 parts - window + left/right status
- [tmux-spotify-info](https://github.com/jdxcode/tmux-spotify-info) Spotify track info on your status bar (OSX)
- [tmux-spotify-info](https://github.com/Feqzz/tmux-spotify-info) Spotify track info on your status bar (Linux)
- [tmux-transient-status](https://github.com/TheSast/tmux-transient-status) Automatically make your tmux status bar vanish when unneded.
- [tmux-weather](https://github.com/jdxcode/tmux-weather) Add weather status via forcast.io
- [tmux-weather](https://github.com/xamut/tmux-weather) Show current weather using wttr.in
- [tmux-window-name](https://github.com/ofirgall/tmux-window-name) Names your tmux windows smartly.
- [tmux-weather-info-yr](https://github.com/Feqzz/tmux-weather-info-yr) Displays the current temperature and weather based on your location via yr.no
- [tmux-world-clock](https://github.com/alexanderjeurissen/tmux-world-clock) Show multiple timezones using Olson tz database.

## Plugins

- [tmux2html](https://github.com/tweekmonster/tmux2html) :cat2: Render full tmux windows or individual panes as HTML
- [tmux-better-mouse-mode](https://github.com/NHDaly/tmux-better-mouse-mode) A tmux plugin to better manage and configure the mouse.
- [extrakto](https://github.com/laktak/extrakto) tmux clipboard copy and output completions
- [muxile](https://github.com/bjesus/muxile) - View and control your tmux session from your mobile.
- [tmux-autoreload](https://github.com/b0o/tmux-autoreload) - Watches your tmux configuration file and automatically reloads it on change.
- [tmux-bitwarden](https://github.com/Alkindi42/tmux-bitwarden) Access your Bitwarden login items in a tmux pane.
- [tmux-browser](https://github.com/ofirgall/tmux-browser) Web browser sessions attached to tmux sessions.
- [tmux-cht-sh](https://github.com/kenos1/tmux-cht-sh) Access cheatsheets easily in a popup
- [tmux-copytk](https://github.com/CrispyConductor/tmux-copy-toolkit) - Multi utility rapid copy toolkit.
- [tmux-easy-motion](https://github.com/IngoMeyer441/tmux-easy-motion) vim-easymotion like navigation for tmux.
- [tmux-fingers](https://github.com/Morantron/tmux-fingers) copy pasting in terminal with vimium/vimperator like hints.
- [tmux-fuzzback](https://github.com/roosta/tmux-fuzzback) Search your scrollback buffer using fzf.
- [tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url) For opening urls from browser quickly without mouse.
- [tmux-fzf-session-switch](https://github.com/thuanOwa/tmux-fzf-session-switch) Easy way to switch, when you have a ton of sessions.
- [tmux-keylocker](https://github.com/TheSast/tmux-keylocker) Lock away your tmux keybinds temporarely.
- [tmux-menus](https://github.com/jaclu/tmux-menus) - Popup menus to help with managing your environment.
- [tmux-modal](https://github.com/whame/tmux-modal) - Execute complex tmux commands in just a few keystrokes with a modal mode that is designed to be efficient, easy to remember and comfortable.
- [tmux-mouse-swipe](https://github.com/jaclu/tmux-mouse-swipe) - Switch Window or Session by clicking right mouse button and swiping.
- [tmux-notify](https://github.com/rickstaa/tmux-notify) A plugin to notify you when processes are finished.
- [tmux-open-nvim](https://github.com/trevarj/tmux-open-nvim) - A plugin to help open files in a running instance of Neovim. Pairs well with tmux-fingers or tmux-open.
- [tmux-thumbs](https://github.com/fcsonline/tmux-thumbs) A lightning fast version of tmux-fingers written in Rust, copy/pasting tmux like vimium/vimperator
- [tmux-1password](https://github.com/yardnsm/tmux-1password) Access your 1Password login items in a tmux pane.
- [tmux-jump](https://github.com/schasse/tmux-jump) Vimium/Easymotion like navigation for tmux.
- [tmux-power-zoom](https://github.com/jaclu/tmux-power-zoom) Zoom pane to separate window, then unzoom it back into it's original location.
- [tmux-session-wizard](https://github.com/27medkamal/tmux-session-wizard) One prefix to control all your session creation, naming, switching, etc using [fzf](https://github.com/junegunn/fzf) & [zoxide](https://github.com/ajeetdsouza/zoxide).
- [tmux-simple-git-status](https://github.com/kristijanhusak/tmux-simple-git-status) Show branch and number of changes in current git repository
- [tmux-spotify](https://github.com/xamut/tmux-spotify) Show a nice menu to manage Spotify application
- [tmux-spotify-playlists](https://github.com/danjeltahko/spotify-tmux) Another Spotify plugin, but for saving and playing your favorite playlists
- [tmux-super-fingers](https://github.com/artemave/tmux_super_fingers) like fingers, but also opens files in vim.
- [tmux-tilish](https://github.com/jabirali/tmux-tilish) Turn tmux into a dynamic window manager with intuitive keybindings (inspired by i3wm/sway)
- [tmux-timetrap](https://github.com/croxarens/tmux-timetrap) Keep your time tracked directly with TMUX (The plugin is just a wrapper for [timetrap](https://github.com/samg/timetrap))
- [tmux-wormhole](https://github.com/gcla/tmux-wormhole) Use tmux to download files with magic wormhole
- [tmux-pianobar](https://github.com/GoHarder/tmux-pianobar) A menu and status bar widget for Pianobar
- [tmux-plugins](https://github.com/tmux-plugins) Official tmux plugins
  - [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) Continuous saving of tmux environment. Automatic restore when tmux is started. Automatic tmux start when computer is turned on.
  - [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat) A plugin that enhances tmux search
  - [tmux-fpp](https://github.com/tmux-plugins/tmux-fpp) Quickly open any path on your terminal window in your $EDITOR of choice!
  - [tmux-logging](https://github.com/tmux-plugins/tmux-logging) Easy logging and screen capturing for Tmux.
  - [tmux-open](https://github.com/tmux-plugins/tmux-open) Tmux key bindings for quick opening of a highlighted file or url
  - [tmux-pain-control](https://github.com/tmux-plugins/tmux-pain-control) standard pane key-bindings for tmux
  - [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) Persists tmux environment across system restarts.
  - [tmux-sessionist](https://github.com/tmux-plugins/tmux-sessionist) Lightweight tmux utils for manipulating sessions
  - [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar) A sidebar with the directory tree for the current path. Tries to make tmux more IDE like.
  - [tmux-tpm](https://github.com/tmux-plugins/tpm) Tmux Plugin Manager
  - [tmux-urlview](https://github.com/tmux-plugins/tmux-urlview) Quickly open any url on your terminal window! (No commits since 2016, see tmux-urlscan or tmux-fzf-url for a maintained alternative.)
  - [tmux-yank](https://github.com/tmux-plugins/tmux-yank) Tmux plugin for copying to system clipboard. Works on OSX, Linux and Cygwin.

### Development and testing

- [tmux-example-plugin](https://github.com/tmux-plugins/tmux-example-plugin) Example Tmux plugin that actually demonstrates how to build plugins for Tmux
- [tmux-test](https://github.com/tmux-plugins/tmux-test) A small framework for isolated testing of tmux plugins.

## Books

- [tmux 2: Productive Mouse-Free Development](https://pragprog.com/book/bhtmux2/tmux-2/)
- [The Tao of tmux](https://leanpub.com/the-tao-of-tmux)

## Miscellaneous

- [sixel-tmux](https://github.com/csdvrx/sixel-tmux) a fork of tmux, with just one goal: having the most reliable support of graphics
- [Statically linked tmux](https://gist.github.com/rothgar/719ef460efc214c8d222) Install new version without root access
- [sublime-tmux](https://github.com/huntie/sublime-tmux) Sublime Text plugin to interact with tmux sessions
- [vim-tmux](https://github.com/tmux-plugins/vim-tmux) vim plugin for tmux.conf
- [tmux-tail-f](https://github.com/mapio/tmux-tail-f) A tool to tail multiple files using tmux