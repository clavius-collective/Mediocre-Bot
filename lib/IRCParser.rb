class IRCParser
  attr_reader :input_string, :prefix, :command, :middle, :trailing
  
  @@letter_regex = "[a-zA-Z]"
  @@number_regex = "[0-9]"
  @@special_regex = "[-\\[\\]\\`\^\{\}]"
  @@non_white_regex = "[^\x20\x0\xd\xa]"
  @@user_regex = @@non_white_regex + "+"
  @@chstring_regex = "[^\x20\x7\x0\xd\xa]+"
  @@mask_regex = "(#|$)" + @@chstring_regex
  @@nick_regex = @@letter_regex + "(#{@@letter_regex}|#{@@number_regex}|#{@@special_regex})*"
  @@host_regex = "^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$"
  @@servername_regex = @@host_regex
  @@channel_regex = "(#|&)" + @@chstring_regex

  def initialize(input)
    @input_string = input
    @stripped_input = input.strip
    if @stripped_input[0] == ":"
      split_input = @stripped_input[1..-1].split(/ +/,2)
      @prefix = split_input[0]
      @command_params = split_input[1]
    else
      @prefix = ""
      @command_params = @stripped_input
    end
    split_input = @command_params.split(/ +/,2)
    @command = split_input[0]
    @params = split_input[1]
    split_input = @params.split(":",2)
    @middle = split_input[0].split(/ +/)
    if split_input.length == 2
      @trailing = split_input[1]
    else
      @trailing = ""
    end
  end
end
