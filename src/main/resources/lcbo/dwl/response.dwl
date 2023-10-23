%dw 2.0
output application/json
import * from dw::Runtime
fun volumeStrToNum(volStr) = do{ 
    var parts = volStr splitBy (" x ")
    ---
    (parts[0] * parts[1])
}

fun getVolume(unitVolumeStr) = do{
    var vol = try(() -> volumeStrToNum(unitVolumeStr))
    ---
    if(vol.success) vol.result else 0
}
---
payload.results map ((item, index) -> do{
    var volume = item.raw.lcbo_total_volume default getVolume(item.raw."lcbo_unit_volume")
    var percent = item.raw.lcbo_alcohol_percent default 0
    var price = item.raw.ec_promo_price default item.raw.ec_price
    ---
    {
    	"type": vars.productType.displayName,
        name: item.title,
        uri: item.uri,
        volume: volume,
        percent: percent,
        price: price,
        totalAlcoholContent: volume * percent / 100,
        volumeByPrice: ((volume * percent / 100) / price) as String {format:"#.###"} as Number
    }
}) 