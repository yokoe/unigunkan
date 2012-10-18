require 'pathname'

class Unigunkan::Processor
  def initialize(proj_file, opts)
    @proj_file = proj_file
    @opts = opts
  end

  def create_backup
    STDOUT.puts "Creating a backup of project.pbxproj..."
    backup_filepath = @proj_file + ".backup" + Time.now.strftime("%Y%m%d%H%M%S")
    FileUtils.cp(@proj_file, backup_filepath)
    STDOUT.puts "A backup created -> #{backup_filepath}"
  end

  def disable_retina_4inch_support(src)
    STDOUT.puts "Disabling Retina 4inch support..."
    dst = src.split("\n")
    src = ""
    lines_removed = 0
    for line in dst
      if line.index("Default-568h@2x.png") == nil
        src += "#{line}\n"
      else
        lines_removed += 1
      end
    end
    if lines_removed > 0
      STDOUT.puts "#{lines_removed} lines removed."
    else
      STDOUT.puts "Default-568h@2x.png not found in this project. No lines removed."
    end

    begin
      default_png_path = Pathname.new(@proj_file + "/../../Default-568h@2x.png").realpath
      FileUtils.mv default_png_path, default_png_path.to_s + ".backup" + Time.now.strftime("%Y%m%d%H%M%S")
    rescue
      STDOUT.puts "Warning: No Default-568h@2x.png found."
    end

    return dst
  end
end