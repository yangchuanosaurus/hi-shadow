module Shadow
    VERSION_INFO        = [1, 0, 0, 'rc1'].freeze
    VERSION             = VERSION_INFO.map(&:to_s).join('.').freeze
    VERSION_LATES       = 'latest'

    LATEST_UPDATE_DATE  = 'May 24, 2018'

    def self.version
        VERSION
    end

    def self.date
        LATEST_UPDATE_DATE
    end
end