# Rationale for cutpodcast.bash

I really love podcasts. Now it is very easy to play them in phones, tablets or smart devices. They are able to remember the exact point where the playing was paused or stopped and so, they can easily resume the audition from that point.

However, there are still devices on which playing is not so easy. Old mp3 players, or specialized players (e.g. for swimming or cars), have very limited controls and it can be very annoying to stop a large podcast in minute 78 and, when resuming, discover that it is in minute 0.

The script cutpodcast.bash seeks to solve that problem by including the following features:

* It cuts large podcasts in fragments of a maximum size, expressed in seconds
* It includes a TTS (Text to Speech) prefix to easily identify the fragment.
* It copies the fragments in the target device very carefully to avoid the disorder of tracks caused by the optimizing strategies of operating systems  (it makes a "sync" to flush writing buffers between copies)

# Requirements

cutpodcast.bash requires:

* A bash installation, better in Linux, but it could work in other systems
* ffmpeg. An impressive set of tools for audio and video streams.
* id3tool. Tool to manage tags in mp3 files.
* gtts-cli. The Google engine for TTS that makes use of web services

# Use

```bash
cutpodcast <file> <seconds> <album> <directory> <text>
```

Where:

* **\<file\>** is the large mp3 file to cut
* **\<seconds>** is the maximum size in seconds of each fragment (excluding TTS prefix)
* **\<album\>** is the tag for the album that serves to make the file names for the fragments
* **\<directory\>** is the folder where the tagged and prefixed fragments are copied.
This directory is intended to be part of a removable storage
* **\<text\>** is the text which, together with the track number, forms the "speech" prefix of all tracks 