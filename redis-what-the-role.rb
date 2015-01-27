#!/usr/bin/env ruby
#
# redis! what the role????
#
# simple HTTP server that can be used in a HA Proxy redis cluster
# to establish whether a particular node is a master or slave
#
# inspired by:
#
#  * this blog post: http://failshell.io/sensu/high-availability-sensu/
#  * not wanting to run xinetd to execute a shell script as 
#    suggested in the blog post
#
# http://github.com/roobert/redis-what-the-role
#

require 'webrick'

class RedisWhatTheRole
  def self.start
    server = WEBrick::HTTPServer.new :Port => 6380
    server.mount_proc '/' do |request, response|
      response.status, response.reason_phrase, response.body = reply
    end

    trap 'INT' do server.shutdown end
    server.start
  end

  def self.reply
    begin
      role = `redis-cli info replication 2>&1`
      raise StandardError, "#{role}" if $?.to_i != 0

      case role
      when /role:master/ then [ 200, "OK", "i'm a redis master" ]
      when /role:slave/  then [ 503, "Service Unavailable", "i'm a redis slave" ]
      else                    [ 501, "Internal Server Error", "unknown role: #{role}"]
      end
    rescue => e
      [ 501, "Internal Server Error", "Unable to establish redis server role: #{e}" ]
    end
  end
end

RedisWhatTheRole.start
