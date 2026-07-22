# To print a message there are couple of commands, but echo is widely use one

echo "Hello World"

# While printing some tims to grab attention we can use -e option to enable interpretation of backslash escapes

#syntax: echo -e "message"
#echo -e "\e[COLmmessage\e[0m"  #COL is color code, 0m is to reset the color]"

#\e[COLm - To enable color, where COL is the color code]
#\e[0m - To reset the color back to default
echo -e "\e[30mHello World\e[0m"
echo -e "\e[31mHello World\e[0m"
echo -e "\e[32mHello World\e[0m"
echo -e "\e[33mHello World\e[0m"
echo -e "\e[34mHello World\e[0m"
echo -e "\e[35mHello World\e[0m"
echo -e "\e[36mHello World\e[0m"

# COL stands for color and possible color codes are as below
# 30 - Black
# 31 - Red
# 32 - Green
# 33 - Yellow
# 34 - Blue
# 35 - Magenta
# 36 - Cyan     