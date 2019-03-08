# Docker
A repository for useful Docker files.

## toolbox
Contains:
  * Dider Steven's suite (https://blog.didierstevens.com/didier-stevens-suite/)
  * nmap
  * WhatWaf (https://github.com/Ekultek/WhatWaf)
  * WES-NG (https://github.com/bitsadmin/wesng)
  * CyberChef (https://gchq.github.io/CyberChef/)
  
Build with:
  * `docker build -t toolbox:latest d:\docker\toolbox -f d:\docker\toolbox\toolbox.dockerfile`
  
Run with:
  * `docker run -p 127.0.0.1:8888:8888 -v d:\docker\toolbox\ext:/work/ext --rm toolbox`
  
Notes:
  * When run with the volume (`-v`) switch, this binds the container path `/work/ext` to `d:\docker\toolbox\ext`, change the host path as needed.  This allows for saving any files out to the host filesystem by placing them in the "ext" folder.  This is useful for persistance of Jupyter Notebooks, results files, or anything which should survive the reinitialization of the container.  
  * The container exposes a Jupter Notebook Server on port 8888 to the localhost address.  After the container is initialized, it can be accessed with a web browser on `http://127.0.0.1:8888?token=<token>`.  Console output from the `docker run` command will provide the `<token>` needed to access this server.
