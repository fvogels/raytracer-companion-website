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
      @difficulty ||= extension_difficulty(@path)
    end

    def order
      @order ||= extension_order(@path)
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

      generate_category(top_level_categories.children['first-steps'], false)
      generate_category(top_level_categories.children['extensions'], true)
      generate_category(top_level_categories.children['reference'], false)

      @lines
    end

    def generate_category(category, is_extension)
      generate_header(category.name, category.depth + 1)
      generate_subcategories(category.subcategories, is_extension)
      generate_entries(category.child_entries, is_extension)
    end

    def generate_header(title, level)
      generate_line "#{"#" * level} #{title.split('-').map(&:capitalize).join(' ')}"
      generate_line ""
    end

    def generate_subcategories(subcategories, is_extension)
      subcategories.sort_by(&:name).each do |subcategory|
        generate_category(subcategory, is_extension)
      end
    end

    def generate_entries(entries, is_extension)
      return if entries.empty?

      if is_extension
        generate_line('[.center,options="header", cols="^1,^9",width="60%"]')
      else
        generate_line('[.center,cols="^",width="60%"]')
      end

      generate_line('|===')

      if is_extension
        generate_line('| Difficulty | Extension ')
      end

      entries.sort_by do |entry|
        if is_extension
          [ entry.order || entries.size, entry.name ]
        else
          entry.name
        end
      end.each do |entry|
        generate_entry(entry, is_extension)
      end

      generate_line('|===')
      generate_line ''
    end

    def generate_entry(entry, is_extension)
      relative_path = entry.path.relative_path_from(Pathname.new('docs').expand_path)
      title = explanations_title entry.path

      if is_extension
        difficulty = entry.difficulty

        raise "Could not find difficulty in #{entry.path}" unless difficulty

        generate_line "| #{difficulty} | <<#{relative_path.to_s}#,#{title}>>"
      else
        generate_line "| <<#{relative_path.to_s}#,#{title}>>"
      end
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