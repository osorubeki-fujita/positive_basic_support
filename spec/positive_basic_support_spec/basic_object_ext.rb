module UpperNamespaceTest
  module A
    module B
      module C
      
      end
      
      module C::D
      
      end
      
    end
  end
end

describe BasicObject do
  it "can get upper namespace by \.upper_namespaces" do
    expect( ::UpperNamespaceTest::A.upper_namespaces ).to eq( [ ::UpperNamespaceTest ] )
    expect( ::UpperNamespaceTest::A::B.upper_namespaces ).to eq( [ ::UpperNamespaceTest::A , ::UpperNamespaceTest ] )
  end
end