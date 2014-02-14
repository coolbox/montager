#!/home/software/ruby-1.8.4/bin/ruby -w
#
# Simple demo program for RMagick
#
# Concept and algorithms lifted from Magick++ demo script written
# by Bob Friesenhahn.
#
require 'RMagick'
include Magick

#
#   RMagick version of Magick++/demo/demo.cpp
#

Font = "Helvetica"

begin
    puts "Read images..."

    model = ImageList.new("1.jpg")
    model.border_color = "black"
    model.background_color = "black"
    model.cur_image[:Label] = "RMagick"

    smile = ImageList.new("2.jpg")
    smile.border_color = "black"
    smile.cur_image[:Label] = "Smile"

    #
    #   Create image stack
    #
    puts "Creating thumbnails"

    # Construct an initial list containing five copies of a null
    # image. This will give us room to fit the logo at the top.
    # Notice I specify the width and height of the images via the
    # optional "size" attribute in the parm block associated with
    # the read method. There are two more examples of this, below.
    example = ImageList.new
    5.times { example.read("NULL:black") { self.size = "200x200"} }


    # To add an Image in one of ImageMagick's built-in formats,
    # call the read method. The filename specifies the format and
    # any parameters it needs. The gradient format can be created in
    # any size. Specify the desired size by assigning it, in the form
    # "WxH", to the optional "size" attribute in the block associated
    # with the read method. Here we create a gradient image that is
    # the same size as the model image.
    puts "   scale..."
    example << model.scale(0.80)
    example.cur_image[:Label] = "Scale"

    #
    #   Create image montage - notice the optional
    #   montage parameters are supplied via a block
    #

    puts "Montage images..."

    montage = example.montage {
        self.geometry = "130x194+10+5>"
        self.gravity = CenterGravity
        self.border_width = 1
        rows = (example.size + 4) / 5
        self.tile = Geometry.new(5,rows)
        self.compose = OverCompositeOp

        # Use the ImageMagick built-in "granite" format
        # as the background texture.

#       self.texture = Image.read("granite:").first
        self.background_color = "white"
        self.font = Font;
        self.pointsize = 18;
        self.fill = "#600"
        self.filename = "RMagick Demo"
#       self.shadow = true
#       self.frame = "20x20+4+4"
    }

    # Add the ImageMagick logo to the top of the montage. The "logo:"
    # format is a fixed-size image, so I don't need to specify a size.
    # puts "Adding logo image..."
    # logo = Image.read("logo:").first
    # if /GraphicsMagick/.match Magick_version then
    #     logo.resize!(200.0/logo.rows)
    # else
    #     logo.crop!(98, 0, 461, 455).resize!(0.45)
    # end

    # # Create a new Image for the composited montage and logo
    # montage_image = ImageList.new
    # montage_image << montage.composite(logo, 245, 0, OverCompositeOp)

    # Write the result to a file
    # montage_image.compression = RunlengthEncodedCompression
    montage.matte = false
    puts "Writing image ./rm_demo_out.jpg"
    montage.write "rm_demo_out_test.jpg"

    # Uncomment the following lines to display image to screen
    # puts "Displaying image..."
    # montage_image.display

rescue
    puts "Caught exception: #{$!}"
end

exit



# montage *.jpg -thumbnail 300x300 -set caption %t -bordercolor #E6E6FA -background grey40 -pointsize 9 -density 144x144 +polaroid -resize 50%  -background white -geometry +1+1 -tile 2x2 -title "Pinglers!" polaroid_t.jpg