#!/usr/bin/env ruby

# file: gtk2keypress123.rb

require 'gtk2'
require 'gtk2keypress'
require 'dynarex'


class Gtk2KeyPress123 < Gtk2KeyPress
  using ColouredText
  
  def initialize(timeout: 0.8, notifier: nil, exit_on_success: false, 
                  keywords: nil, terminator: 'qq', debug: false)

    @terminator, @debug = terminator, debug

    @h = if keywords then
    
      puts 'keywords : ' + keywords.inspect if @debug
      
      obj, _ = RXFHelper.read keywords, debug: debug, auto: true
      
      puts 'obj: ' + obj.inspect if @debug
      
      if obj and obj.respond_to? :to_h then
        obj.to_h 
      else
        {}
      end
    end
    
    puts '@h: ' + @h.inspect if @debug
    
    @buffer = []
    @timeout, @notifier, @exit = timeout, notifier, exit_on_success

    window = Gtk::Window.new 'Gtk2KeyPress123'

    window.add(Gtk::Label.new("Press 1 or more keys!"))

    key = super(window)
    window.set_default_size(300, 120).show_all

    window.signal_connect( "destroy" ) {
       destroy( nil )
    }

  end

  def on_keypress(e)

    t = Time.now
    puts 'key press ' + e.name if @debug
    @buffer ||= []
    @buffer << e.name

    Thread.new do

      # after the time has elapsed the message will be sent unless 
      # the buffer is empty

      while t + @timeout > Time.now do        
        sleep 0.2
      end

      if @buffer.length > 0 then

        puts ('buffer: ' + @buffer.inspect).debug if @debug
        destroy(nil) if @h and @terminator == @buffer.join

        if @h and @notifier then
          s = @buffer.all? {|x| x.length  < 2} ? '' : ', '          
          puts ('@h: ' + @h.inspect).debug if @debug
          fqm = @h[@buffer.join(s)]
          puts ('fqm: ' + fqm.strip.inspect).debug if @debug
          @notifier.notice fqm.strip if fqm
          #sleep 0.4
        end

        @buffer = []

        if @exit then
          puts 'bye'
          sleep 0.4
          exit
        end
      end

    end

  end

  def start
    Gtk.main
  end

  private

  def destroy( widget)
     Gtk.main_quit
  end


end

