# -*- encoding: UTF-8 -*-
require File.expand_path(File.join('spec_helper'), File.dirname(__FILE__))

describe FileRef do
  it "should be created from a hash" do
    name = "libz.dylib"
    path = "usr/lib/libz.dylib"
    last_known_type = "compiled.mach-o.dylib"
    ref = FileRef.new({name: name, last_known_type: last_known_type, path: path, source_tree: :SDKROOT})
    ref.id.should_not be_nil
    ref.name.should == name
    ref.path.should == path
    ref.last_known_type.should == last_known_type
    ref.isa.should == :PBXFileReference

    puts ref.to_s
  end
end