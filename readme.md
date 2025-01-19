# What is this?
This repo was me scrating an itch. I wanted to come up with a template that i could use when writing bash scripts, i quite like the python way of doing things, using a main function which will only get called if the main script is called directly which not only splits up the code into a nice readable style but also allows you to test the functions.

Which leads to the second reason, i wanted to find out how easy it would be to propery unit test a bash script. Im happily supprised.

# Running the script
Just run `./main.sh` passing any flags that you need, these will be passed on to the main.sh in the source folder. All the code runs from the toplevel directory, not from `./source/`.

## But its broken
Yes i know the function `do_the_foo` does not exist, i will replace this with something more real, maybe just check your external ip address or something basic, i will have a think.

# Running the tests
Just run `./test.sh` this will dynamically scan all the files matching `test_*` inside the tests folder. At the moment sub folders will not be run although i dont think it would be hard to change that.

The tests will output details of which tests are run and a summary of the results. I'm thinking that we could also output test results in a standard, im interested in generating a report in the CTRF format https://ctrf.io/docs/intro

# outcome
I've been quite please with what i managed to acheive whilst sticking with the zero dependency approach. There are a couple of bash testing frameworks out there but since i knocked this up over the course of a weekend im not sure you really need them. This way everything is under my control and there is less chance of anyone injecting security vulnerabilities and the upgrade and supported shell is entirely in my control.

## Testing
Testing bash like this is a little hit and miss though, its easy to accidently break other tests, especially if you are mocking out functions. You also have to be diligent in the way you pass variables and the return values you are returning.

I dont like that i have to use +e effectivly ignoring errors in the test suite, if you use -e then when things return non zero results the whole script stops, which is not ideal.

## Assertions
You are only allowed one assertion per test unless you chain them correctly with `&&` you can see this in one test `test_should_do_foo`, i need some more complex code to stretch the limits of this technique, but to be honest i like one assert per test anyway.
