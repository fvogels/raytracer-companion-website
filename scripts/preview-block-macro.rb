require 'asciidoctor'
require 'asciidoctor/extensions'
require 'pathname'


class PreviewBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  named :preview

  def process parent, target, attrs
    document_directory = Pathname.new parent.document.attributes['docdir']

    create_section(parent, 'Preview', {}).tap do |open_block|
      open_block.role = 'preview'
      attrs = { **attrs, "target" => "#{target}.mp4", "align" => "center" }

      open_block << create_block(open_block, :video, nil, attrs).tap do |video_block|
        video_block.set_option('autoplay')
        video_block.set_option('loop')
      end

      filename = document_directory.join("#{target}.chai")
      file_contents = filename.readlines.map(&:rstrip)
      open_block << create_listing_block(open_block, file_contents, { 'language' => 'chai'}).tap do |listing_block|
        listing_block.style = 'source'
        listing_block.set_option('nowrap')
        listing_block.commit_subs
      end
    end
  end
end

class PreviewBlockMacroDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl

  def process doc
    <<~END
      <style>
        .preview .listingblock {
          border: 1px solid black;
          box-shadow: #AAA 5px 5px;
          width: 90%;
          margin: 1em auto;
        }

        .preview .listingblock pre {
          max-height: 15em;
          overflow: auto;
        }
      </style>'
    END
  end
end