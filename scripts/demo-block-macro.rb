require 'asciidoctor'
require 'asciidoctor/extensions'
require 'pathname'


class DemoBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  named :demo

  def process parent, target, attrs
    document_directory = Pathname.new parent.document.attributes['docdir']

    create_open_block(parent, [], {}).tap do |open_block|
      attrs = { **attrs, "target" => "#{target}.mp4", "align" => "center" }

      open_block << create_block(open_block, :video, nil, attrs).tap do |video_block|
        video_block.set_option('autoplay')
        video_block.set_option('loop')
      end

      filename = document_directory.join("#{target}.chai")
      file_contents = filename.readlines.map(&:rstrip)
      open_block << create_listing_block(open_block, file_contents, {}).tap do |listing_block|
        listing_block.set_option('nowrap')
        listing_block.role = 'demo-source'
      end
    end
  end
end

class DemoBlockMacroDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl

  def process doc
    <<~END
      <style>
        .listingblock.demo-source {
          border: 1px solid black;
          box-shadow: #AAA 5px 5px;
        }

        .listingblock.demo-source pre {
          max-height: 15em;
          overflow: scroll;
        }
      </style>'
    END
  end
end