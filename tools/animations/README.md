# Info

Blender is needed to render and create the frames.

Before doing this I recommend you clean the frames folder, and make a backup of the frames.

Open up the blend file in blender, then do what you want to do, hit render animation.

The frames should go to the frames folder.

In the scripts folder, there is a ruby script.

If you don't have ruby installed, https://www.ruby-lang.org/en/

If you have ruby installed, then you need the gem rcairo, this is the graphics library I used.

http://rcairo.github.io/

If you have all that installed, then from the CLI

`ruby path_to_the_script_location`

simple as that.