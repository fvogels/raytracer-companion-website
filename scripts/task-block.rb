require 'asciidoctor'
require 'asciidoctor/extensions'


class TaskBlock < Asciidoctor::Extensions::BlockProcessor
  use_dsl
  named :TASK
  on_context :example

  def process(parent, reader, attrs)
    attrs = {**attrs, "name" => 'task', "caption" => 'test'}
    create_block(parent, :admonition, reader.readlines, attrs, content_model: :compound)
  end
end

class TaskBlockDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl

  def process doc
    <<~END
      <style>
        .admonitionblock.task > table > tbody > tr > td.icon .title::before {
          content: "🔨";
          color: #871452;
        }

        .admonitionblock.task > table {
          border: 1px solid black;
          box-shadow: gray 5px 5px 5px;
          background: #DDF;
        }
      </style>
    END
  end
end