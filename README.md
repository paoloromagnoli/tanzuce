# Install Tanzu Community Edition with Salt

These are Salt state files to install Tanzu Community Edition and prerequisitites on Ubuntu 20.04 / 18.04 desktop.

If you are familiar with Salt instructions are pretty simple:  you just need to apply the init.sls against your minion. Just be aware that TCE doesn't need it, however my automation creates a user named tce. This user has disabled interactive login, it is placed in sudo and docker groups and finally it is allowed for password-less sudo. If you are not happy with one of these just make your changes, but you need to keep tce in the docker group.  

## If you are not familiar with Salt
Don't worry, I wrote a blog post with [step-by-step end-to-end guide including installing Salt](https://nine30.info). 
