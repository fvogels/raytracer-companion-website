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
    lines += generate_difficulty(overview_data[:difficulty])
    lines += generate_prerequisities(overview_data[:requires])
    lines += generate_exclusive_rows(overview_data[:excludes])
    lines += generate_reading_material(overview_data[:reading])
    lines << '|==='

    create_open_block(parent, [], attrs).tap do |b|
      b.role = 'overview'
      parse_content(b, lines, {})
    end
  end

  private
  def parse_overview(lines)
    result = { requires: [], excludes: [], reading: [], difficulty: nil }

    lines.each_with_object(result) do |line, result|
      case line
      when /^(requires|excludes|reading) (.*)$/
        result[$1.to_sym] << $2
      when /^difficulty (.*)$/
        result[:difficulty] = $1
      else
        abort "Unknown overview entry: #{line}"
      end
    end
  end

  def generate_difficulty(difficulty)
    [ "| *Difficulty* | #{difficulty}" ]
  end

  def generate_prerequisities(extensions)
    generate_rows('*Prerequisites*', extensions, 'extensions')
  end

  def generate_exclusive_rows(extensions)
    generate_rows('*Mutually exclusive with*', extensions, 'extensions')
  end

  def generate_reading_material(references)
    generate_rows('*Reading material*', references, 'reference')
  end

  def generate_rows(header, extensions, category)
    headers = Enumerator.new do |yielder|
      yielder << header
      while true
        yielder << ''
      end
    end

    extensions.zip(headers).map do |extension, header|
      "| #{header} | <</#{category}/#{extension}/explanations#,#{extension}>>"
    end
  end
end

class OverviewBlockMacroDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl

  def process doc
    <<~END
      <style>
        .overview {
          width: 80%;
          margin: 1em auto;
          box-shadow: #BBB 10px 10px 10px;
        }
      </style>'
    END
  end
end