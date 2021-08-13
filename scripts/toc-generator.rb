require 'find'
require 'pathname'
require_relative 'util'


module TOCGeneration
  class Category
    def initialize(name, depth)
      raise "Invalid name #{name}" unless name

      @name = name
      @depth = depth
      @children = {}
    end

    attr_reader :name, :depth, :children

    def subcategories
      children.values.select { |child| Category === child }
    end

    def child_entries
      children.values.select { |child| Entry === child }
    end
  end

  class Entry
    def initialize(name, path)
      @name = name
      @path = path
    end

    attr_reader :name, :path

    def difficulty
      contents = path.read


    end
  end

  class Generator
    def initialize
      @lines = []
    end

    def generate
      top_level_categories = collect_categories('docs')

      generate_line '# Overview'
      generate_line ''

      generate_category(top_level_categories.children['extensions'])
      generate_category(top_level_categories.children['reference'])

      @lines
    end

    def generate_category(category)
      generate_header(category.name, category.depth + 1)
      generate_subcategories(category.subcategories)
      generate_entries(category.child_entries)
    end

    def generate_header(title, level)
      generate_line "#{"#" * level} #{title.capitalize}"
      generate_line ""
    end

    def generate_subcategories(subcategories)
      subcategories.sort_by(&:name).each do |subcategory|
        generate_category subcategory
      end
    end

    def generate_entries(entries)
      generate_line('[cols="^,^"]')
      generate_line('|===')

      entries.sort_by(&:name).each do |entry|
        generate_entry entry
      end

      generate_line('|===')
      generate_line ''
    end

    def generate_entry(entry)
      relative_path = entry.path.relative_path_from(Pathname.new('docs').expand_path)
      difficulty = extension_difficulty(entry.path)

      generate_line "| <<#{relative_path.to_s}#,#{entry.name.capitalize}>> | #{difficulty}"
    end

    def generate_line(str)
      @lines << str
    end

    def collect_categories(path, depth = 0)
      Dir.chdir(path) do
        explanations_path = Pathname.new('explanations.asciidoc').expand_path

        if explanations_path.file?
          Entry.new(path, explanations_path)
        else
          category = Category.new(path, depth)

          Dir['*'].each do |entry|
            pathname = Pathname.new(entry).expand_path
            raise "Unexpected file #{pathname.to_s}" if pathname.file?

            category.children[entry] = collect_categories(entry, depth + 1)
          end

          category
        end
      end
    end
  end
end

def generate_toc
  lines = TOCGeneration::Generator.new.generate
  content = lines.join("\n")
  target_pathname = Pathname.new('dist/overview.html').expand_path
  compile_asciidoc_string(content, target_pathname)
end