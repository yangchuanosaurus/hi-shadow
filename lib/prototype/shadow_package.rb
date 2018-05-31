module ShadowSolution
    @@package_name

    class Package
        def self.set(package_name)
            @@package_name = package_name
            puts "Package didSet #{package_name}"
        end

        def self.name
            @@package_name
        end
    end
end