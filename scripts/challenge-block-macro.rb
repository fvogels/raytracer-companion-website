require 'asciidoctor'
require 'asciidoctor/extensions'
require 'pathname'
require_relative './util.rb'


class ChallengeBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  named :challenge

  def process parent, target, attrs
    document_directory = Pathname.new parent.document.attributes['docdir']
    target_absolute_path = document_directory.join("#{target}.chai")

    create_section(parent, 'Challenge', {}).tap do |open_block|
      open_block.role = 'challenge'
      attrs = { **attrs, "align" => "center" }

      case chai_type(target_absolute_path)
      when 'movie'
        attrs = { **attrs, "target" => "#{target}.mp4" }
        open_block << create_block(open_block, :video, nil, attrs).tap do |video_block|
          video_block.set_option('autoplay')
          video_block.set_option('loop')
        end
      when 'image'
        attrs = { **attrs, "target" => "#{target}.png" }
        open_block << create_image_block(open_block, attrs)
      else
        abort "Unrecognized tag in #{target_absolute_path}"
      end
    end
  end
end
