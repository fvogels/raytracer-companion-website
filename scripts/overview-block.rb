require 'asciidoctor'
require 'asciidoctor/extensions'


class OverviewBlock < Asciidoctor::Extensions::BlockProcessor
  use_dsl
  named :overview
  on_context :listing
  parse_content_as :raw

  def process(parent, reader, attrs)
    overview_contents = reader.read_lines
    overview_data = parse_overview overview_contents

    lines = [ "" ]
    lines << '[cols="1,2"]'
    lines << '|==='
    lines += generate_exclusive_rows(overview_data[:excludes])
    lines << '|==='

    create_open_block(parent, [], attrs).tap do |b|
      parse_content(b, lines, {})
    end
  end

  private
  def parse_overview(lines)
    result = { excludes: [] }

    lines.each_with_object(result) do |line, result|
      case line
      when /^excludes (.*)$/
        result[:excludes] << $1
      else
        abort "Unknown overview entry: #{line}"
      end
    end
  end

  def generate_exclusive_rows(extensions)
    generate_rows('Mutually exclusive with', extensions)
  end

  def generate_rows(header, extensions)
    headers = Enumerator.new do |yielder|
      yielder << header
      while true
        yielder << ''
        p '.'
      end
    end

    extensions.zip(headers).map do |extension, header|
      "| *#{header}* | #{extension}"
    end
  end
end