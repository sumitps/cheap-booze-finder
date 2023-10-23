%dw 2.0
output application/json
var filter = if ( !isEmpty(vars.maxPrice) ) 
	"@ec_price=0.." ++ ceil(vars.maxPrice) ++ "|@ec_category=" ++ vars.productType.name
else
	"@ec_category=" ++ vars.productType.name

var limit = Mule::p('lcbo.limit')
---
{
	headers: {
		"Authorization": "Bearer xx883b5583-07fb-416b-874b-77cce565d927",
		"Content-Type": "application/json"
	},
	body: {
		"aq": filter,
		"locale": "en",
		"firstResult": payload * limit,
		"numberOfResults": limit,
		"facets": [{
			"facetId": "@ec_category",
			"field": "ec_category",
			"type": "hierarchical",
			"injectionDepth": 1000,
			"delimitingCharacter": "|",
			"filterFacetCount": true,
			"basePath": ["Products",
                "Spirits",
                "Whisky"],
			"filterByBasePath": false
		},
        {
			"facetId": "@stores_stock",
			"field": "stores_stock",
			"type": "specific",
			"injectionDepth": 1000,
			"filterFacetCount": true,
			"currentValues": [{
				"value": "false",
				"state": "idle"
			},
                {
				"value": "true",
				"state": "selected"
			}],
			"numberOfValues": 2
		}],
		"dictionaryFieldContext": {
			"stores_stock": vars.storeId,
			"stores_inventory": vars.storeId,
			"stores_stock_combined": vars.storeId,
			"stores_low_stock_combined": vars.storeId
		}
	},
	queryParams: {
	}
}