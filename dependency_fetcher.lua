--[[ 
    Extremely simple plug-and-play lua script designed to automatically fetch and download dependencies from Github when using the Premake build system.
    This script is licensed under the Unlicense, meaning this script is purely public domain and can be modified, used, and distributed in any way with or without
    credit to the original author.
]]

local DependencyFetcher = {}

function DependencyFetcher.FetchRepo(url, targetDir, commitID)
    if not os.isdir(targetDir) then
        print("[DependencyFetcher] Cloning " .. url .. " to " .. targetDir)
        
        -- Clone the repo using --depth 1 for efficient downloading.
        local result = os.execute("git clone --depth 1 " .. url .. " " .. targetDir)
        if not result then
            error("[DependencyFetcher] Failed to clone repository: " .. url)
        end
        
        -- Since we often may need specific commits, we have an option to load a specific commit ID.
        -- The way we can do this is since we've already cloned our repo, we jump to the working directory of wherever we store the third party libraries.
        -- and fetch the specific commit ID we want, then checkout the commit.
        if commitID then
            print("[DependencyFetcher] Checking out commit: " .. commitID)
            local checkoutCmd = string.format("git -C %s fetch --depth 1 origin %s && git -C %s checkout %s", 
                                               targetDir, commitID, targetDir, commitID)
            local checkoutResult = os.execute(checkoutCmd)
            if not checkoutResult then
                error("[DependencyFetcher] Failed to checkout commit: " .. commitID)
            end
        end
    else
        print("[DependencyFetcher] Directory already exists: " .. targetDir)
    end

end

function DependencyFetcher.Setup()

    print("\n[DependencyFetcher] Fetching dependencies...")
    
    --------- Place your dependencies here. Example below of how to use:
    --[[ 
    DependencyFetcher.FetchRepo("https://github.com/juvenilerex/dependency.git", -- Example Github repo link. Replace with your own.
        "thirdparty/exampledep", -- What directory to download it to. The directory "exampledep" will be automatically created by this script, inside the "thirdparty" directory starting from root. Replace with your own.
        "3atr6ndrahjfz7p8wezenm3w9j5wgxvfxjrxedhk") -- OPTIONAL: The commit ID (will be a 40 character long string that looks like this). Replace with your own.
    ]]

    print("[DependencyFetcher] Dependency fetch completed!\n")
    
end

return DependencyFetcher