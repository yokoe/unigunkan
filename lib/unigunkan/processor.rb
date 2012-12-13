require 'fileutils'
require 'pathname'
require 'securerandom'

class Unigunkan::Processor
  def initialize(proj_file, opts)
    @proj_file = proj_file
    @opts = opts

    f = open(@proj_file)
    @src = f.read
    f.close
  end

  def create_backup
    STDOUT.puts "Creating a backup of project.pbxproj..."
    backup_filepath = @proj_file + ".backup" + Time.now.strftime("%Y%m%d%H%M%S")
    FileUtils.cp(@proj_file, backup_filepath)
    STDOUT.puts "A backup created -> #{backup_filepath}"
  end

  # Disable iphone5 support
  # (Remove lines which include 'Default-568h@2x.png'.)
  def disable_retina_4inch_support
    src = @src
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

    @src = src
  end

  def add_folder_refs
    if OPTS[:folder_refs].nil?
      return
    end

    folders = OPTS[:folder_refs].split(",")

    STDOUT.puts "Adding folder refs..."

    file_refs_to_add = []
    build_files_to_add = []
    resource_build_phase_files_to_add = []
    entry_in_tree_to_add = []

    for folder in folders
      file_ref = SecureRandom.hex
      build_file = SecureRandom.hex
      file_refs_to_add << "#{file_ref} /* #{folder} */ = {isa = PBXFileReference; lastKnownFileType = folder; path = #{folder}; sourceTree = \"<group>\"; };"
      build_files_to_add << "#{build_file} /* #{folder} in Resources */ = {isa = PBXBuildFile; fileRef = #{file_ref} /* #{folder} */; };"
      resource_build_phase_files_to_add << "#{build_file} /* #{folder} in Resources */,"
      entry_in_tree_to_add << "#{file_ref} /* #{folder} */,"
    end
    puts build_files_to_add.join("\n")
    puts file_refs_to_add.join("\n")
    puts resource_build_phase_files_to_add.join("\n")
    puts entry_in_tree_to_add.join("\n")

    add_block_after "/* Begin PBXBuildFile section */", build_files_to_add.join("\n")
    add_block_after "/* Begin PBXFileReference section */", file_refs_to_add.join("\n")

    # Rewrite ResourcesBuildPhase section
    target = /Resources \*\/ = {\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = (.*?);\n\t\t\tfiles = \(/
    mask = @src.scan(target)[0][0]
    build_phases = "Resources */ = {\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = #{mask};\n\t\t\tfiles = (\n"
    @src.gsub!(target, build_phases + resource_build_phase_files_to_add.join("\n"))

    # Rewrite PBXGroup section
    target = /\/\* Begin PBXGroup section \*\/\n\t\t(.*?)\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = \(/
      # isa = PBXGroup;
      # children = \("
    p @src.scan(target)
    group_id = @src.scan(target)[0][0]
    group = "/* Begin PBXGroup section */
\t\t#{group_id}
\t\t\tisa = PBXGroup;
\t\t\tchildren = ("
    @src.gsub!(target, group + "\n" + entry_in_tree_to_add.join("\n"))
  end

  def new_uuid
    SecureRandom.hex(10)
  end

  def link_library(library, path)
    fileref = FileRef.new({name: library, last_known_type: "compiled.mach-o.dylib", path: path, source_tree: :SDKROOT})
    if library.end_with?(".dylib")
      @src = Modifier.add_build_files(@src, fileref.build_file.to_s)
      @src = Modifier.add_file_ref(@src, fileref.to_s)
      @src = Modifier.add_framework_build_phase(@src, fileref.build_file.key)
    else
      puts "Unsupported: #{library}"
    end
  end

  def integrate_testflight_sdk(sdk_path, token)
    puts "Integrate TestFlight SDK #{sdk_path}, #{token}"
    link_library "libz.dylib", "usr/lib/libz.dylib"
  end

  def add_block_after(line, block)
    @src.gsub!(line, line + "\n" + block)
  end

  def delete_original_project_file
    FileUtils.rm @proj_file
  end

  def write
    open(@proj_file, "w") {|f|
      f.puts @src
    }
  end
end