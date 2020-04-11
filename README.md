# armbian-musicbox

Why this project? I wanted to use an orange pi zero as music center. 
I tried several solutions (there are several like runeaudio, volumio, pi musicbox and many more. 
None of them really supports orange pi zero officially or didn't work nicely on it. 

So I started to create my own build for it. The concept is, that it does not create a distibution but builds on top on it. 
That way it should be possible to create  music box for any device that is supported by a debian based distribution (like armbian). 

At the moment the script downloads the armbian image for the orange pi zero and creates the image that that can be put on the sc card by using dd. 
In the future the base image should be configurable so that the script can be used for any base image. 
Furthermore the shell scripts could be replaced by ansible. 
