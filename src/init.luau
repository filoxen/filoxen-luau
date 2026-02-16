local module = {}

local HttpService = game:GetService("HttpService")
local RbxAssetUtils = require(script.Packages.RbxAssetUtils)
local Types = RbxAssetUtils.Types

-- Change this to your own API instance URL if self-hosting.
local API_URL_BASE = "https://filoxen.example.com"
-- Name of the secret in the Secrets Store (Creator Dashboard -> Secrets).
local API_KEY_SECRET_NAME = "FILOXEN_API_KEY"

local API_KEY = HttpService:GetSecret(API_KEY_SECRET_NAME)

-- Makes a GET request to the Filoxen API and decodes the assets array from the response.
local function makeApiRequest(url: string): {Types.Asset}?
	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = url,
			Method = "GET",
			Headers = {
				["x-api-key"] = API_KEY
			}
		})
	end)
	if success and response.Success then
		local decodeSuccess, responseData = pcall(HttpService.JSONDecode, HttpService, response.Body)
		if not decodeSuccess then
			warn(`[Filoxen] API response decode failed: {tostring(responseData)}`)
			return {}
		end
		local assets: {Types.Asset}? = responseData["assets"]
		if not assets then
			warn("[Filoxen] API response missing 'assets' field")
			return {}
		end
		return assets
	else
		local errorMessage = if success then `HTTP {response.StatusCode}: {response.StatusMessage}` else tostring(response)
		warn(`[Filoxen] API request failed: {errorMessage}`)
		return {}
	end
end

-- Fetches random assets from the Filoxen API with the given filters.
function module.random(assetTypeIds: {number | Enum.AssetType}, maxAssetId: number?, minAssetId: number?, batch: number, onsale: number | boolean?, playable: number?): {Types.Asset}?
	local REQUEST_URL = `{API_URL_BASE}/assets/random?assetTypeIds={table.concat(assetTypeIds, ',')}&batch={batch}`
	if type(onsale) == "boolean" then
		onsale = if onsale then 1 else 0
	end
	for i, assetTypeId in ipairs(assetTypeIds) do
		if typeof(assetTypeId) == "EnumItem" then
			assetTypeIds[i] = assetTypeId.Value
		end
	end
	if maxAssetId then
		REQUEST_URL = `{REQUEST_URL}&maxAssetId={maxAssetId}`
	end
	if minAssetId then
		REQUEST_URL = `{REQUEST_URL}&minAssetId={minAssetId}`
	end
	if onsale then
		REQUEST_URL = `{REQUEST_URL}&onsale={onsale}`
	end
	if playable then
		REQUEST_URL = `{REQUEST_URL}&playable={playable}`
	end
	return makeApiRequest(REQUEST_URL)
end

-- Searches for assets matching a query string via the Filoxen API.
function module.search(query: string, assetTypeId: number, page: number?): {Types.Asset}?
	if not page then page = 1 end
	local REQUEST_URL = `{API_URL_BASE}/assets/search?assetTypeId={assetTypeId}&query={HttpService:UrlEncode(query)}&page={page}`
	return makeApiRequest(REQUEST_URL)
end

return module
