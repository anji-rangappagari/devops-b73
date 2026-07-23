#search and replace word (s) in a file using sed command in Linux.
#delete line (d)
#add some lines (a)#
sed -i 's|nologin|yeslogin|' /etc/passwd  # Replace old_word with new_word in the file (-i option is used to edit the file in place)


sed '|yeslogin|d' /etc/passwd  # Delete the line containing the word "yeslogin" in the file 

sed '5 a Hello World' /etc/passwd  # Add the line "Hello World" after the 5th line in the file