require 'spec_helper'

describe GryphonSitemap::HasSitemap do
  let!(:adapter) { ActiveRecord::Base.connection }

  before :all do
    adapter.create_table :foos, :force => true do |t|
      t.string :name
    end
  end

  after :all do
    adapter.drop_table :foos
  end

  after :each do
    Object.send(:remove_const, :Foo)
  end

  context "basic usage" do
    before do
      class Foo < ActiveRecord::Base
        attr_accessible :name
        has_sitemap
      end
    end

    describe "sitemap_page_count" do
      it "returns no pages with no data" do
        Foo.should_receive(:count).and_return(0)
        Foo.sitemap_page_count.should == 0
      end

      it "returns one page for one item" do
        Foo.should_receive(:count).and_return(1)
        Foo.sitemap_page_count.should == 1
      end

      it "returns 1 page for 5,000 entries" do
        Foo.should_receive(:count).and_return(5000)
        Foo.sitemap_page_count.should == 1
      end

      it "returns 2 pages for 5,001 entries" do
        Foo.should_receive(:count).and_return(5001)
        Foo.sitemap_page_count.should == 2
      end

      it "pages with 10,000 items" do
        Foo.should_receive(:order).with(:id).and_return(Foo)
        Foo.should_receive(:limit).with(5000).and_return(Foo)
        Foo.should_receive(:select).with([:id, :updated_at]).and_return(Foo)
        Foo.should_receive(:offset).with(0).and_return([5000])

        Foo.sitemap_page(0).should == [5000]
      end
    end
  end

  context "basic usage" do
    before do
      class Foo < ActiveRecord::Base
        attr_accessible :name
        has_sitemap :fields => :name, :per_page => 20
      end
    end

    describe "options" do
      it "returns 100 pages for 2,000 entries" do
        Foo.should_receive(:count).and_return(2000)
        Foo.sitemap_page_count.should == 100
      end
      
      it "pages with 2,000 items" do
        Foo.should_receive(:order).with(:id).and_return(Foo)
        Foo.should_receive(:limit).with(20).and_return(Foo)
        Foo.should_receive(:select).with([:id, :updated_at, :name]).and_return(Foo)
        Foo.should_receive(:offset).with(0).and_return([20])

        Foo.sitemap_page(0).should == [20]
      end
      
    end
  end

end
