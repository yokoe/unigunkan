class Modifier
  def self.add_build_files(src, files)
    return add_block_after(src, "/* Begin PBXBuildFile section */", files)
  end

  def self.add_file_ref(src, files)
  	return add_block_after(src, "/* Begin PBXFileReference section */", files)
  end

  def self.add_framework_build_phase(src, files)
    target = /Frameworks \*\/ = {\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = (.*?);\n\t\t\tfiles = \(/
    mask = src.scan(target)[0][0]
    build_phases = "Frameworks */ = {\n\t\t\tisa = PBXFrameworksBuildPhase;\n\t\t\tbuildActionMask = #{mask};\n\t\t\tfiles = (\n"
    return src.gsub(target, build_phases + files + ",")
  end

  def self.add_block_after(src, line, block)
    src.gsub!(line, line + "\n" + block)
  end
end