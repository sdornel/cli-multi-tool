module RenameFile
    extend self
    def change_filename_text
        puts 'Enter the directory. Default is current directory.'
        directory = $stdin.gets.chomp
        directory = "." if directory.empty?

        puts 'Enter file extension (.mp3, .odt, .txt) or leave blank.'
        file_extension = $stdin.gets.chomp

        puts 'Enter text you want replaced.'
        old_text = $stdin.gets.chomp

        puts 'Enter replacement text'
        new_text = $stdin.gets.chomp

        puts "Searching with pattern: #{directory}/#{file_extension}"

        Dir.glob("#{directory}/*#{file_extension}").each do |file_path|
            dir_name = File.dirname(file_path)
            base_name = File.basename(file_path)

            # Replace the old_text with new_text in the filename
            new_base_name = base_name.gsub(old_text, new_text)
            new_file_path = File.join(dir_name, new_base_name)
    
            File.rename(file_path, new_file_path)
        end
    end
end