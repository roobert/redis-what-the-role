# redis! what the role????

simple HTTP server that can be used in a HA Proxy redis cluster to establish whether a particular node is a master or slave

inspired by:
* this blog post: http://failshell.io/sensu/high-availability-sensu/
* not wanting to run xinetd to execute a shell script as suggested in the blog post

usage:
```
# server
./redis-what-the-role.rb

# client
curl localhost:6380
```
