#!/usr/bin/env ruby
require 'cairo'

# Create Frame Class for easier handling.
class Frame
    # Allow Values to be Accessed Public.?
    attr_accessor :width
    attr_accessor :height
    attr_accessor :x
    attr_accessor :y

    #Constructor: 
    def initialize(width = 16, height = 16, x = 0, y = 0)
        @width = width; 
        @height = height; 

        # @data = nil
        @image = nil

        @x = x
        @y = y

        @context = nil
     end

    # UNUSED FOR NOW    
    # def get_data(source)
    #     @data = File.read(source); 
    # end

    # UNUSED FOR NOW
    # def set_data(data)
    #   @data = data
    # end

    def get_image(file_location)
      @image = Cairo::ImageSurface.from_png(file_location)
    end

    def set_image(image)
      @image = image
    end

    def set_context(context)
      @context = context
    end

    def set_coordinates(x, y)
      @x = x
      @y = y
    end

    def scale_frame()
      @width = @image.width
      @height = @image.height
    end

    def draw_frame(x = @x, y = @y)
      @context.set_source(@image, x, y)
      @context.paint
    end
end

#-------------------#
# Start Actual Code #
#-------------------#

# Get the directory, need to change to choose directory
top_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", 'frames'))

# Defined some basic var
width = 16
height = 16

draw_y = 0
draw_x = 0

# $ Just means global variable.
$total_width = 0
$total_height = 0
$total_frames = 0


# Inefficient but calculate the image width/height
# Do this because you can't resize without creating a new instance every time
# Creating a singular extra instance is faster.
Cairo::ImageSurface.new(width, height) do |fake_surface|
  fake_ctx = Cairo::Context.new(fake_surface)

  Dir.foreach(top_dir) do |file_name|
    if ( file_name.end_with?("png") )

      $total_frames += 1

      file_location = File.join(top_dir, file_name)

      fake_frame = Frame.new

      fake_frame.get_image(file_location)
      fake_frame.set_context(fake_ctx)
      fake_frame.scale_frame()

      $total_width = fake_frame.width
      $total_height += fake_frame.height
    end
  end
end

# Actually Draw the frames
Cairo::ImageSurface.new($total_width, $total_height) do |surface|
  ctx = Cairo::Context.new(surface)
  Dir.foreach(top_dir) do |file_name|
    if ( file_name.end_with?("png") ) 

      file_location = File.join(top_dir, file_name)

      frame = Frame.new
      frame.get_image(file_location)
      frame.set_context(ctx)
      frame.scale_frame()

      frame.set_coordinates(draw_x, draw_y)
      frame.draw_frame()

      draw_y += frame.height
      draw_x = 0
    end
  end

  # Write to png, self explanitory
  surface.write_to_png("#{$total_frames}.png")
end

# Example of different type of write other then default, need to research
#
# Cairo::ImageSurface.new(data, :argb32, width, height, stride) do |surface|
#   surface.write_to_png("test-renew.png")
# end