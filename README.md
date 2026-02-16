# filoxen-luau

Luau client library for the Filoxen asset API. Fetch random or search for Roblox assets.

## Installation

Requires [Wally](https://wally.run).

```toml
[dependencies]
Filoxen = "secret-rare/filoxen-luau@0.1.0"
```

```sh
wally install
```

## Setup

1. Add your Filoxen API key as a secret in the [Creator Dashboard](https://create.roblox.com) under Secrets (defaults to `FILOXEN_API_KEY`).
2. Make sure `HttpService` is enabled for your game.

## Usage

```luau
local Filoxen = require(path.to.Filoxen)

-- Must be called once before any other function
Filoxen.configure({
    baseUrl = "https://your-filoxen-instance.com",
    apiKeySecretName = "FILOXEN_API_KEY", -- optional, this is the default
})

-- Fetch 10 random hats
local assets = Filoxen.random(
    { Enum.AssetType.Hat },  -- assetTypeIds
    nil,                     -- maxAssetId
    nil,                     -- minAssetId
    10,                      -- batch
    true                     -- onsale
)

-- Search for assets by name
local results = Filoxen.search("blue hat", Enum.AssetType.Hat.Value)
```

