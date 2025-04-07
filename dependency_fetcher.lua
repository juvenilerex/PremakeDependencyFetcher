--[[ 
    Extremely simple plug-and-play lua script designed to automatically fetch and download dependencies from Github when using the Premake build system.
    This script is licensed under the Unlicense, meaning this script is purely public domain and can be modified, used, and distributed in any way with or without
    credit to the original author.
]]

local DependencyFetcher = {}

function DependencyFetcher.FetchRepo(url, targetDir, treeName, commitID)
    if not os.isdir(targetDir) then
        print("[DependencyFetcher] Cloning " .. url .. " to " .. targetDir)
        
        -- Base clone command that we'll append our needed data onto if we have a specific branch we want to pull.
        local cloneCmd = "git clone --depth 1"
        
        -- If a tree name is provided, we'll add the --branch option to the clone command.
        -- This works for branches and should work for tags as well.
        if treeName then
            print("[DependencyFetcher] Targeting tree: " .. treeName)
            cloneCmd = cloneCmd .. " --branch " .. treeName
        end
        
        -- Append the URL onto it.
        cloneCmd = cloneCmd .. " " .. url .. " " .. targetDir
        
        local result = os.execute(cloneCmd)
        if not result then
            error("[DependencyFetcher] Failed to clone repository: " .. url .. (treeName and (" (tree: " .. treeName .. ")") or ""))
        end

        if commitID then
            print("[DependencyFetcher] Checking out specific commit: " .. commitID)
            -- Using --depth 1 could possibly cause issues for very old commits. It should work for most.
            -- But modify it if there is trouble.
            local fetchCmd = string.format("git -C %s fetch --depth 1 origin %s", targetDir, commitID)
            local fetchResult = os.execute(fetchCmd)

            local checkoutCmd = string.format("git -C %s checkout %s", targetDir, commitID)
            local checkoutResult = os.execute(checkoutCmd)
            if not checkoutResult then
                error("[DependencyFetcher] Failed to checkout commit: " .. commitID)
            end
        end

    else
        -- In the future, support for existing directories and overwriting could be nice.
        print("[DependencyFetcher] [Warning] Found existing: " .. targetDir .. " (no new files were added/changed)")
    end

end

function DependencyFetcher.Setup()

    print("\n[DependencyFetcher] Fetching dependencies...")
    
    --------- Place your dependencies here. Example below of how to use:
    --[[ 
    
    DependencyFetcher.FetchRepo("https://github.com/juvenilerex/dependency.git", -- Example Github repo link. Replace with your own.
        "thirdparty/exampledep", -- What directory to download it to. The directory "exampledep" will be automatically created by this script, inside the "thirdparty" directory starting from root. Replace with your own.
        "master", -- What tree/tag to use. Leave as "master" if you want the default.
        "3atr6ndrahjfz7p8wezenm3w9j5wgxvfxjrxedhk") -- OPTIONAL: The commit ID (will be a 40 character long string that looks like this). Replace with your own or leave blank.

    ]]

    print("[DependencyFetcher] Dependency fetch completed!\n")
    
end

return DependencyFetcher