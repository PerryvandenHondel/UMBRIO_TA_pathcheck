
# PathCheck

When not having access to the console of a Linux system to check for file specs 
that need to be ingested by Splunk use this PathCheck Splunk TA.

Reads from a list of file specs to mark these as FOUND or NOT_FOUND in a 
index into Splunk.


## Setup


### pathcheck.list
The pathcheck.list file is located in the bin directory and contains a list of
file specs of paths to check.
```
## Specific template file specs.
/var/log/dummy/api.log
/var/log/dummy/backup.log
/var/log/dummycinder.log

## File spec template with a wild-card.
/var/log/dummy*.log
/var/log/*/dummy.log
```

### inputs.conf
Copy the app into the deployment-apps directory of the Deployment Server

Edit the local/inputs.conf to match your preferred settings

```
[script://$SPLUNK_HOME/etc/apps/da_00base_pathcheck/bin/pathcheck]
disabled = 0
interval = 180

[monitor:///tmp/pathcheck.log]
index = ix_sandbox
sourcetype = support:pathcheck
disabled = 0
```


## Deployment

Deploy the app to a system using the Splunk Deployment Server 

## Usage/Examples

In Splunk in the index ix_sandbox or your own specified index

```
index=ix_sandbox source="/tmp/pathcheck.log"
| table host template path file_size datetime_last_modified status
```
Shows the files that are found by the pathcheck app.

### Fields

* template; is the file spec as used in the pathcheck.list to check for.
* path; is the full path of the file that is found using the template.
* file_size; the size of the file in bytes.
* datetime_last_modified; the date time of the file of the last modification.
* status; can have the following status: FOUND of NOT_FOUND.
 
