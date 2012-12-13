class Modifier
  def self.add_build_files(src, files)
    return add_block_after(src, "/* Begin PBXBuildFile section */", files)
  end

  def self.add_block_after(src, line, block)
    src.gsub!(line, line + "\n" + block)
  end
end