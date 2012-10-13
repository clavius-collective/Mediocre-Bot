class Channel

  def initialize(channel_name)
    @channel_name = channel_name
    @users = Hash.new
  end

  def update(action, user, key = nil)
    case action
    when "quit"
      @users.delete(user.nick)
    when "nick_change"
      change_user_nick(key,user)
    end
  end

  def add_user(user)
    @users[user.nick] = user
    user.add_observer(self)
  end

  def change_user_nick(previous_nick, user)
    @users.delete(key)
    @users[previous_nick] = user
  end

end
