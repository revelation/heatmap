module Heatmap
  class Image

    POINT    = File.new(File.dirname(__FILE__) + "/../assets/point.png", 'r')
    GRADIENT = File.new(File.dirname(__FILE__) + "/../assets/gradient.png", 'r')

    def initialize(area, file)
      raise(ArgumentError, "Area needs to be an array of Heatmap::Area objects") if area.empty?

      file   = File.new(file, 'w')
      bounds = Heatmap::Geometry.bounds(area, 100)

      # Creating a blank canvas
      system("convert -alpha Transparent -size #{bounds.width}x#{bounds.height} canvas:white #{file.path}")
      # system("convert #{file.path} -transparent black NikeProd.png")
      # system("convert -size #{bounds.width}x#{bounds.height} -alpha transparent #{file.path}")
      # system("convert #{file.path} -alpha transparent #{file.path}")

      # Drawing each area
      compose = ["convert #{file.path}"]
      compose << area.map{|area| "-page #{area.x_y} #{POINT.path}" }
      compose << "-alpha remove #{file.path}"
      system(compose * ' ')

      # Applying color with a LUT
      system("convert -channel ALL -clut #{file.path} #{GRADIENT.path} #{file.path}")

      # Apply a default 50% opacity
      system("mogrify -channel A -fx \"A*0.50\" #{file.path}")

      file.close
    end

  end
end