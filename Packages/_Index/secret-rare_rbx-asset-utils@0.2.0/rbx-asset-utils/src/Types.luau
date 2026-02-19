local module = {}

-- Asset Data Types
export type Asset = {
	id: number,
	name: string,
	description: string,
	price: number?,
	type: number,
	creator: number,
	creator_name: string,
	creator_type: "User" | "Group",
	creator_target_id: number,
	onsale: number,
	public_domain: number,
	limited: number,
	limited_unique: number,
	created_at: string,
	updated_at: string
}


return module
