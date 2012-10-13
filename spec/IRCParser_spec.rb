require 'rspec'
require_relative '../lib/IRCParser.rb'

describe IRCParser do 
  it "should parse a irc 'message' with a prefix and a trailing" do
    @input_string = ":card.freenode.net NOTICE * :*** Looking up your hostname...\r\n"
    @test_message = IRCParser.new(@input_string)
    @test_message.input_string.should == @input_string 
    @test_message.prefix.should == "card.freenode.net"
    @test_message.command.should == "notice"
    @test_message.middle.should == ["*"]
    @test_message.trailing.should == "*** Looking up your hostname..."
  end

  it "should parse a irc 'message' with a prefix and no trailing" do
    @input_string = ":zelazny.freenode.net 354 Stephenr 152 #mcgill ilybot H"
    @test_message = IRCParser.new(@input_string)
    @test_message.prefix.should == "zelazny.freenode.net"
    @test_message.command.should == "354"
    @test_message.middle.should == %w{Stephenr 152 #mcgill ilybot H}
    @test_message.trailing.should == ""
  end
end
