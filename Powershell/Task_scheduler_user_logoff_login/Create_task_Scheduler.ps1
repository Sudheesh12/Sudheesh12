# this script will run the XML file a admin and create the task scheduler

schtasks /Create /TN "RunOnUserLogoff" /XML "C:location of the file" /F