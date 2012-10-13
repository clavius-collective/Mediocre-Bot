require_relative '../lib/IRCConnector.rb'

config = {
  'port' => 6667,
  'server' => 'irc.freenode.net',
  'username' => 'medibot',
  'real_name' => 'medibot',
  'nick' => 'test123525',
  'nickserv_password' => '',
  'channels' => ["#mcgill-bottest"]
}

EventMachine::run do
  EventMachine::connect 'irc.freenode.net', 6667, MediocreBot::IRCConnector, config
end 
