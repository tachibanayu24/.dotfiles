# frozen_string_literal: true

# Select Editor
Pry.config.editor = 'vim'

# Execute even when the beginning of a line is a method
Pry.commands.delete '.<shell command>'

# gem install
gems = %w[awesome_print hirb]
gems.each do |gem|
  begin
    before_modules = ObjectSpace.each_object(Module).to_a

    if require gem
      output.puts "#{text.bright_yellow(gem)} loaded"
      loaded_modules = ObjectSpace.each_object(Module).to_a - before_modules
      print_module_tree(loaded_modules)
    else
      output.puts "#{text.bright_white(gem)} already loaded"
    end
  rescue LoadError => e
    if gem_installed? gem
      output.puts e.inspect
    else
      output.puts '#{gem.bright_red} not found'
      if prompt('Install the gem?') == 'y'
        run 'gem-install', gem
        run 'req', gem
      end
    end
  end
end

# Enviromnent
Pry.config.prompt = proc do |obj, nest_level, _pry_|
  version = ''
  version << "#{RUBY_VERSION}"

  "#{version} #{Pry.config.prompt_name}(#{Pry.view_clip(obj)})> "
end

# Colorize
def Pry.set_color sym, color
  CodeRay::Encoders::Terminal::TOKEN_COLORS[sym] = color.to_s
  { sym => color.to_s }
end
