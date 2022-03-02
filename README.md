# devyn-dj

NOTE: I do NOT provide any support for this script.

Requirements: qb-target, xsound

![image](https://user-images.githubusercontent.com/7463741/156465563-138a8b8c-12d5-48c1-a90d-0ae9cbf2549b.png)
 This script allows you to place multiple dj booths in your server to play youtube links.
 Booths can be changed in the server/main.lua
 
 ```
 local Booths = {
    ['test'] = {
        ['radius'] = 40,
        ['coords'] = vector3(120.55, -1281.63, 29.48), 
        ['playing'] = false,
        ['job'] = "none",
    },
}
```


The booth can only be used by those with the set job for the booth.
Players with the permissions admin or god can open any dj booth.

