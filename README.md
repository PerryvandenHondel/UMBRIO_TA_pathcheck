Splunk Techical Add-on to check for valid paths on a client.


# Installation
Add the app under de deployment-apps dir of your Deployment Server under: 

/opt/splunk/etc/deployment-apps

Create a inputs.conf under the local dir of the app

```
[monitor:///tmp/pathcheck.log]
index = ix_sandbox
sourcetype = support:pathcheck
disabled = 0
```


# List File
The list file (pathcheck.list) holds all the paths that need to be checked

Format:
```
/dir/dir2/file.txt
/dir2/dir3/*.log
```

Place this file under de directory

```
/opt/splunk/etc/deployment-apps/UMBRIO_TA_pathcheck/bin/pathcheck.list
```