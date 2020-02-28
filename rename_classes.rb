# frozen_string_literal: true

files = Dir.glob("#{Dir.pwd}/lib/facts/el/**/*.rb").map { |e| e.gsub('/Users/gheorghe.popescu/Workspace/facter-ng/lib/facts/', '') }

files.each do |file|
  file_content = File.read(file)
  content = file_content.match(/class .*\n((?:.|\n)*)    end/)[1]
  puts content

  file_name = file.split('/').last
  file_path = file.gsub(file_name, '')

  modules = file_path.gsub("#{Dir.pwd}/lib", '').split('/')[1..-1]

  mod_arr = modules.map(&:capitalize).map { |e| e = "module #{e}" }

  mod_arr << 'class ' + file_name.gsub('.rb', '').split('_').map(&:capitalize).join
  mod_arr << content.strip

  (mod_arr.size - 1).times { mod_arr << 'end' }

  final_content = mod_arr.join("\n")

  File.open(file, 'w') do |f|
    f.puts final_content
  end
end
