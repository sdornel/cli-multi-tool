module RenameFile
    extend self
    def rename_files_with_sequential_naming_pattern
        puts 'Enter the directory. Default is current directory.'
        directory = $stdin.gets.chomp
        directory = "." if directory.empty?

        puts 'Enter file extension (.mp3, .odt, .txt) or leave blank.'
        file_extension = $stdin.gets.chomp

        puts 'Enter text you want replaced.'
        to_replace = $stdin.gets.chomp

        puts 'Enter replacement text'
        replacing = $stdin.gets.chomp
    end
end