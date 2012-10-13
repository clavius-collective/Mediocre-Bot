class User
  include Observable

  attr_reader :nick, :hostname, :username, :nickserv_account
    
  def initialize(nick, hostname = nil, username = nil, nickserv_account = nil)
    @nick = nick
    @hostname = hostname
    @username = username
    @nickserv_account = nickserv_account 
  end

  def quit()
    changed
    notify_observers("quit",self)
  end

  def change_nick(new_nick)
    old_nick = @nick
    @nick = new_nick
    changed
    notify_observers("nick_change",self,old_nick)
  end
end
