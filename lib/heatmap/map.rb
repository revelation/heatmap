module Heatmap
  class Map

    attr_accessor :area

    def initialize
      location = `which convert` || `where convert`
      raise(RuntimeError, "You need to have ImageMagick installed!") if location.nil? || location.strip.empty?
      @area = []
    end

    def <<(item)
      @area << item
    end

    def output(file = 'heatmap.png')
      Heatmap::Image.new(@area, file)
      system("convert #{file.path} -alpha set -channel RGBA -fuzz 1% -fill none -floodfill +0+0 black please_work.png")
    end

  end
end