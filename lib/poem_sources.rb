require 'shellwords'

module PoemSources
  module_function

  def poem_id_for_date(date)
    date.strftime("%Y%m%d").to_i
  end

  def all_sources
    Pathname.glob($poems_src / "*.txt").sort_by { |path| path.basename.to_s.to_i }.each_with_index do |src, index|
      basename = File.basename(src, '.txt')
      text = File.read(src)
      text = text.gsub("\r", "")
      header, body = text.split("---\n", 2)

      tag_lines = header.split("\n")
      tags = tag_lines.each_with_object({}) do |line, map|
        name, value = line.split(/\: ?/)
        map[name] = value
      end

      yield src, index, tags, body, basename
    end
  end

  def parameterize(string)
    Translit.convert(string, :english).downcase.gsub(/[^\w\s]/, '').strip.gsub(/\s+/, '-')
  end
end
