## Purpose
To pull changed files from the development computer to the USB device, and push those files to the local test server. Overwritten files in the local test server will be backed up in the USB device.

## Usage
##### 1. Save pull1.sh and push2.sh in a removable USB device

##### 2. Some variables have to be set priorily
	1. Set below linux environment variable in .bashrc :
    2. $MY_HOME=Your_Project_directory_from_root
    3. Change project_name variable in pull1.sh & push2.sh to your projectname



##### 3. In working_list.txt, write files you want to push. Files' path is relative from project root.
	ex) If file's absolute path is, /home/my_id/working_dicretory/my_project/this_file_changed.py
    and the other is
    /home/my_id/working_directory/myproject/first_directory/the_other_changed.py
    
    In working_list.txt, write as below
    
    this_file_change.py
    first_directory/the_other_changed.py
    
    make sure no space, no blank lines
    
##### 4. Always execute the scripts in directory where pull1.sh push2.sh are.
