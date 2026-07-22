# To print a message there are couple of commands, but echo is widely use one

echo "Hello World"

# While printing some tims to grab attention we can use -e option to enable interpretation of backslash escapes

#syntax: echo -e "message"
#echo -e "\e[COLmmessage\e[0m"  #COL is color code, 0m is to reset the color]"

#\e[COLm - To enable color, where COL is the color code]
#\e[0m - To reset the color back to default
echo -e "\e[32mHello \nWorld\e[0m"