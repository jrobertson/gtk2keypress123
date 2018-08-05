#!/usr/bin/env ruby

# file: gtk2keypress123.rb

require 'gtk2'
require 'gtk2keypress'
require 'dynarex'



class GtkKeyPress123 < Gtk2KeyPress

  def initialize(timeout: 0.8, notifier: nil, exit_on_success: false, 
                  keywords: nil, terminator: 'qq', debug: false)

    @terminator, @debug = terminator, debug

    @h = if keywords then

      obj, _ = RXFHelper.read keywords

      if obj and obj.respond_to? :to_h then
        obj.to_h 
      else
        {}
      end
    end

    @buffer = []
    @timeout, @notifier, @exit = timeout, notifier, exit_on_success

    window = Gtk::Window.new 'Gtk2KeyPress123'

    window.add(Gtk::Label.new("Press 1 or more Keys!"))

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

        destroy(nil) if @h and @terminator == @buffer.join

        if @h and @notifier then
          s = @buffer.all? {|x| x.length  < 2} ? '' : ', '          
          fqm = @h[@buffer.join(s)]
          @notifier.notice fqm if fqm
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

