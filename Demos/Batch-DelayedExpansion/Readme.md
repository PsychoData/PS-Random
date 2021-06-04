[CountingDemo](CountingDemo) shows a basic standard demo of DelayedExpansion. 

In the delayedExpandsion version, the counting shows successfully on screen and the total makes it to 5! 

In the non-delayedExpansion version, the counting seems to fail, but we see that the total still made it to 5. 

This is because the entire `do (commands)` section of the For loop has it's variables expanded at the same time. The command prompt expanded out `do (commands)` and said "OK, I echo this text and add 1 to `_tst`".

While this is fine for many situations, since we are trying to make something that needs to be more dynamic/iterative, it needs to wait (or DELAY \*cough cough\*) to expand that until runtime.

In the Delayed expansion version, the counting doesn't evaluate `!_tst!` until it is running that specific command. 
You can tell it is "that specific command" because the value still counts up in [the MultipleIterations](CountingDemo/DelayedExpansion-Counting-MultipleIterations.bat)

So - why not just run... everything delayed expansion? Well - it saves a lot of time when the command processor can just render all of the variables down to their value and be DONE with it. Delayed expansion is a good bit slower. It probably wouldn't matter until you need to scale up decently, but it is still much slower. 


Another example can be seen in [TimeoutDemo](TimeoutDemo) where the non-delayed expansion returns immediately and all of them show the same time. But the DelayedExpansion one waits as expected!
