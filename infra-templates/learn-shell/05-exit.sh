sample(){
    echo hello
    return 1
    echo bye
}


echo hello
exit
echo bye

# in function we use the return statement to exit the function and return a value to the caller. The return value can be used to indicate success or failure of the function's execution. In this case, the function sample() will print "hello", then return 1, which indicates an error or failure, and will not print "bye".